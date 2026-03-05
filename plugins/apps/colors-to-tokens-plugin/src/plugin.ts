import type { PluginMessageEvent, PluginUIEvent } from './model.js';

const defaultSize = {
  width: 410,
  height: 280,
};

penjar.ui.open('COLORS TO TOKENS', `?theme=${penjar.theme}`, {
  width: defaultSize.width,
  height: defaultSize.height,
});

penjar.on('themechange', (theme) => {
  sendMessage({ type: 'theme', content: theme });
});

penjar.ui.onMessage<PluginUIEvent>((message) => {
  if (message.type === 'get-colors') {
    const colors = penjar.library.local.colors.filter(
      (color) => !color.gradient,
    );

    const fileName = penjar.currentFile?.name ?? 'Untitled';

    sendMessage({
      type: 'set-colors',
      colors,
      fileName,
    });
  } else if (message.type === 'resize') {
    if (
      penjar.ui.size?.width === defaultSize.width &&
      penjar.ui.size?.height === defaultSize.height
    ) {
      resize(message.width, message.height);
    }
  } else if (message.type === 'reset') {
    resize(defaultSize.width, defaultSize.height);
  }
});

function resize(width: number, height: number) {
  if ('resize' in penjar.ui) {
    penjar.ui.resize(width, height);
  }
}

function sendMessage(message: PluginMessageEvent) {
  penjar.ui.sendMessage(message);
}
