import { Text } from '@penjar/plugin-types';
import type {
  PluginMessageEvent,
  PluginUIEvent,
  TextPluginUIEvent,
} from './model.js';
import {
  generateParagraphs,
  generateSentences,
  generateWords,
  generateCharacters,
} from './generator.js';

penjar.ui.open('LOREM IPSUM PLUGIN', `?theme=${penjar.theme}`);

penjar.on('themechange', (theme) => {
  sendMessage({ type: 'theme', content: theme });
});

function getSelectedShapes(): Text[] {
  return penjar.selection.filter((it): it is Text => {
    return penjar.utils.types.isText(it);
  });
}

penjar.on('selectionchange', () => {
  sendMessage({ type: 'selection', content: getSelectedShapes().length });
});

penjar.ui.onMessage<PluginUIEvent>((message) => {
  if (message.type === 'text') {
    generateText(message);

    if (message.autoClose) {
      penjar.closePlugin();
    }
  }
});

function sendMessage(message: PluginMessageEvent) {
  penjar.ui.sendMessage(message);
}

function generateText(event: TextPluginUIEvent) {
  const selection = getSelectedShapes();

  if (!selection.length) {
    const text = penjar.createText('lorem ipsum');
    if (text) {
      text.x = penjar.viewport.center.x;
      text.y = penjar.viewport.center.y;
      selection.push(text);
    }
  }

  selection.forEach((it) => {
    switch (event.generationType) {
      case 'paragraphs':
        it.characters = generateParagraphs(event.size, event.startWithLorem);
        break;
      case 'sentences':
        it.characters = generateSentences(event.size, event.startWithLorem);
        break;
      case 'words':
        it.characters = generateWords(event.size, event.startWithLorem);
        break;
      case 'characters':
        it.characters = generateCharacters(event.size, event.startWithLorem);
        break;
    }
  });
}
