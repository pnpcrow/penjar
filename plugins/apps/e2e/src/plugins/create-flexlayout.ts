export default function () {
  function createFlexLayout(): void {
    const board = penjar.createBoard();
    board.horizontalSizing = 'auto';
    board.verticalSizing = 'auto';

    board.x = penjar.viewport.center.x;
    board.y = penjar.viewport.center.y;

    const flex = board.addFlexLayout();

    flex.dir = 'column';
    flex.wrap = 'wrap';
    flex.alignItems = 'center';
    flex.justifyContent = 'center';
    flex.verticalPadding = 5;
    flex.horizontalPadding = 5;
    flex.horizontalSizing = 'fill';
    flex.verticalSizing = 'fill';

    board.appendChild(penjar.createRectangle());
    board.appendChild(penjar.createEllipse());
  }

  createFlexLayout();
}
