export default function () {
  const rectangle = penjar.createRectangle();
  rectangle.x = penjar.viewport.center.x;
  rectangle.y = penjar.viewport.center.y;

  const shape = penjar.currentPage?.getShapeById(rectangle.id);
  if (shape) {
    penjar.library.local.createComponent([shape]);
  }
}
