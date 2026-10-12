// 全站共用的複製按鈕：任何帶 data-lean-copy 與 data-code 的按鈕都適用。
document.addEventListener('click', async (event) => {
  const target = event.target instanceof Element ? event.target.closest<HTMLButtonElement>('[data-lean-copy]') : null;
  if (!target) return;
  const feedback = target.closest('figure, aside, section')?.querySelector('.copy-feedback');
  const label = target.dataset.label || target.textContent || '複製';
  target.dataset.label = label;
  try {
    await navigator.clipboard.writeText(target.dataset.code || '');
    target.textContent = '已複製';
    if (feedback) feedback.textContent = '已複製到剪貼簿';
    setTimeout(() => { target.textContent = label; }, 1800);
  } catch {
    if (feedback) feedback.textContent = '無法自動複製，請選取文字後手動複製。';
  }
});
