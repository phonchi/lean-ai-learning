"""驗證本機 stdio MCP；不呼叫遠端搜尋、不改寫來源。"""
import asyncio
import json
import os
from pathlib import Path
from datetime import datetime, timezone
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "verification" / "mcp"
OUT.mkdir(parents=True, exist_ok=True)
async def main():
    env = dict(os.environ)
    if (ROOT / ".tools/elan/bin/lake").exists():
        env["ELAN_HOME"] = str(ROOT / ".tools" / "elan")
        env["PATH"] = str(ROOT / ".tools" / "elan" / "bin") + os.pathsep + env["PATH"]
    env["LEAN_LOG_LEVEL"] = "WARNING"
    server = StdioServerParameters(command="uvx", args=["lean-lsp-mcp==0.31.0", "--lean-project-path", str(ROOT / "lean-examples")], env=env)
    results = {"version": "0.31.0", "transport": "stdio", "started_at": datetime.now(timezone.utc).isoformat(), "calls": []}
    with (OUT / "server.log").open("w") as err:
        async with stdio_client(server, errlog=err) as (read, write):
            async with ClientSession(read, write) as session:
                init = await session.initialize()
                results["server"] = init.model_dump(mode="json")
                tools = (await session.list_tools()).tools
                results["tools"] = [{"name":t.name,"schema":getattr(t, "input_schema", None) or getattr(t, "inputSchema", None)} for t in tools]
                print("MCP tools:", ", ".join(t.name for t in tools), flush=True)
                names = {t.name for t in tools}
                calls = [("lean_goal", {"file_path":"Exercises/ProofRepair.lean", "line":4}), ("lean_diagnostic_messages", {"file_path":"Exercises/ProofRepair.lean"}), ("lean_diagnostic_messages", {"file_path":"Course/Projection.lean"})]
                for name, arguments in calls:
                    if name not in names: raise RuntimeError("Missing tool: " + name)
                    result = await session.call_tool(name, arguments)
                    item = {"tool": name, "arguments": arguments, "result": result.model_dump(mode="json")}
                    results["calls"].append(item)
                    (OUT / "results.json").write_text(json.dumps(results,ensure_ascii=False,indent=2)+"\n")
                    print(name, "isError=", getattr(result, "is_error", getattr(result, "isError", False)), flush=True)
                    if getattr(result, "is_error", getattr(result, "isError", False)): raise RuntimeError("MCP tool failed: " + name)
                    payload = json.loads(result.content[0].text)
                    if name == "lean_goal":
                        assert any("P → R" in goal for goal in payload.get("goals_before", [])), payload
                    else:
                        assert payload.get("success") and not payload.get("partial") and not payload.get("timed_out"), payload
                        if arguments["file_path"].startswith("Exercises/"):
                            assert any(item.get("category") == "sorry" for item in payload["items"]), payload
                        else:
                            assert payload["items"] == [], payload
    results["completed_at"] = datetime.now(timezone.utc).isoformat()
    results["passed"] = True
    (OUT / "results.json").write_text(json.dumps(results,ensure_ascii=False,indent=2)+"\n")

asyncio.run(asyncio.wait_for(main(), timeout=300))
