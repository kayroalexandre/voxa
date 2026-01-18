
# Visão Geral do Projeto: Voxa

O Voxa é um aplicativo Flutter projetado para gravar a voz do usuário e transcrevê-la em texto. O objetivo é fornecer uma interface simples e intuitiva para capturar áudio e, eventualmente, processá-lo usando serviços de nuvem.

## Estilo e Design

- **Tema:** O aplicativo usa um tema Material Design padrão com um esquema de cores primário azul.
- **Fonte:** A fonte padrão do sistema é usada.
- **Layout:** O layout é simples e centrado, com uma tela principal que dá as boas-vindas ao usuário e um botão de ação flutuante para iniciar a gravação de voz.
- **Componentes:**
    - `HomeScreen`: A tela principal do aplicativo.
    - `VoiceRecordingSheet`: Uma folha modal que aparece para gravar a voz do usuário.

## Recursos Implementados

- **Gravação de Voz:** O aplicativo pode gravar a voz do usuário usando o microfone do dispositivo.
- **Permissões:** O aplicativo solicita permissão de microfone antes de iniciar a gravação.
- **Armazenamento de Áudio:** O áudio gravado é salvo em um arquivo temporário no dispositivo.
- **Interface do Usuário de Gravação:** Uma folha modal exibe um indicador de gravação e botões para confirmar ou cancelar a gravação.

## Plano para a Próxima Mudança

- **Implementar o Serviço de Transcrição:** O próximo passo é implementar o `TranscriptionService` para transcrever o arquivo de áudio gravado em texto. Isso envolverá o uso de um serviço de nuvem como o Cloud Functions para processar o áudio.
