# Voxa

## Sobre o Projeto

O Voxa é um aplicativo mobile em desenvolvimento, construído com Flutter, que tem como objetivo transformar a voz do usuário em texto de forma clara e intuitiva. O design do aplicativo segue as diretrizes do Material Design 3, focando em uma experiência de usuário moderna, limpa e acessível.

## Status Atual

O projeto está em fase de desenvolvimento iterativo, com foco na construção da interface e na definição da experiência do usuário (UI/UX). As funcionalidades principais estão sendo implementadas conceitualmente e visualmente antes da integração da lógica de backend e gravação de áudio.

Atualmente, o app simula os estados de "parado" e "ouvindo" na tela principal, preparando a base para as funcionalidades de gravação.

## Funcionalidades Implementadas (Visuais e Conceituais)

*   **Simulação de Gravação:** A tela principal responde à interação do usuário, alternando entre um estado "inativo" e um estado "ouvindo", com feedback visual claro (mudança de texto e ícones).
*   **Design System com Material 3:**
    *   Utiliza `ColorScheme.fromSeed` para gerar paletas de cores dinâmicas para os modos claro (light) e escuro (dark).
    *   **Cores Base:** Primária (`0xFF7B61FF`) e Secundária (`0xFFFFD766`).
    *   **Tipografia:** Utiliza a fonte 'Inter' do pacote `google_fonts`.
*   **Tema Dinâmico:** Suporte completo para temas claro e escuro, com componentes que se adaptam automaticamente.

## Arquitetura e Tecnologia

*   **Framework:** Flutter
*   **Gerenciamento de Estado:** `provider`
*   **Roteamento:** `go_router`
*   **Estrutura do Projeto:** Organização por features (Feature-first).
*   **Design:** Material Design 3

## Como Executar o Projeto

Para executar o Voxa em seu ambiente de desenvolvimento, siga os passos abaixo:

1.  **Clone o repositório:**
    ```sh
    git clone <URL_DO_REPOSITORIO>
    cd voxa
    ```

2.  **Instale as dependências:**
    ```sh
    flutter pub get
    ```

3.  **Execute o aplicativo:**
    ```sh
    flutter run
    ```

## Processo de Desenvolvimento

O desenvolvimento deste aplicativo é assistido por IA e segue um processo iterativo documentado no arquivo `blueprint.md`. Cada "Etapa" representa um incremento no desenvolvimento, adicionando novas funcionalidades ou refinando as existentes.
