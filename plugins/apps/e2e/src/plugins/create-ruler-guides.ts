export default function () {
  function createRulerGuides(): void {
    const page = penjar.currentPage;

    if (page) {
      page.addRulerGuide('horizontal', penjar.viewport.center.x);
      page.addRulerGuide('vertical', penjar.viewport.center.y);
    }
  }

  function removeRulerGuides(): void {
    const page = penjar.currentPage;

    if (page) {
      page.removeRulerGuide(page.rulerGuides[0]);
    }
  }

  createRulerGuides();
  removeRulerGuides();
}
