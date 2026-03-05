import type { PluginMessageEvent, PluginUIEvent } from './model.js';

penjar.ui.open('CONTRAST PLUGIN', `?theme=${penjar.theme}`, {
  width: 285,
  height: 525,
});

penjar.ui.onMessage<PluginUIEvent>((message) => {
  if (message.type === 'ready') {
    sendMessage({
      type: 'init',
      content: {
        theme: penjar.theme,
        selection: penjar.selection,
      },
    });

    initEvents();
  }
});

penjar.on('selectionchange', () => {
  const shapes = penjar.selection;
  sendMessage({ type: 'selection', content: shapes });

  initEvents();
});

let listeners: symbol[] = [];

function initEvents() {
  listeners.forEach((listener) => {
    penjar.off(listener);
  });

  listeners = penjar.selection.map((shape) => {
    return penjar.on(
      'shapechange',
      () => {
        const shapes = penjar.selection;
        sendMessage({ type: 'selection', content: shapes });
      },
      { shapeId: shape.id },
    );
  });
}

penjar.on('themechange', () => {
  const theme = penjar.theme;
  sendMessage({ type: 'theme', content: theme });
});

function sendMessage(message: PluginMessageEvent) {
  penjar.ui.sendMessage(message);
}
