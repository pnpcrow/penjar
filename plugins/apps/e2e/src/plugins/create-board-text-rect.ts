import type { Board, Rectangle, Text } from '@penjar/plugin-types';

export default function () {
  function createText(text: string): Text | undefined {
    const textNode = penjar.createText(text);

    if (!textNode) {
      return;
    }

    textNode.x = penjar.viewport.center.x;
    textNode.y = penjar.viewport.center.y;

    return textNode;
  }

  function createRectangle(): Rectangle {
    const rectangle = penjar.createRectangle();

    rectangle.setPluginData('customKey', 'customValue');

    rectangle.x = penjar.viewport.center.x;
    rectangle.y = penjar.viewport.center.y;

    rectangle.resize(200, 200);

    return rectangle;
  }

  function createBoard(): Board {
    const board = penjar.createBoard();

    board.name = 'Board name';

    board.x = penjar.viewport.center.x;
    board.y = penjar.viewport.center.y;

    board.borderRadius = 8;

    board.resize(300, 300);

    const text = penjar.createText('Hello from board');

    if (!text) {
      throw new Error('Could not create text');
    }

    text.x = 10;
    text.y = 10;
    board.appendChild(text);

    return board;
  }

  createBoard();
  createRectangle();
  createText('Hello from plugin');
}
