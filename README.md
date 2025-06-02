# 📖 Meu Livro de Receitas
Um aplicativo Flutter para organizar, editar e compartilhar suas receitas favoritas.

## 📱 Descrição

O **Meu Livro de Receitas** é uma solução digital prática e intuitiva para substituir os tradicionais cadernos de receitas. Ideal para quem deseja registrar suas receitas favoritas, editar facilmente e compartilhar em PDF com amigos e familiares.


## 🎯 Objetivo

Facilitar a organização de receitas pessoais, proporcionando mais praticidade no dia a dia para quem gosta de cozinhar e deseja ter suas receitas sempre à mão, no celular.

## 👤 Público-alvo

Pessoas que utilizam cadernos ou anotações soltas para guardar suas receitas e procuram uma solução mais moderna, acessível e funcional para armazená-las e organizá-las.

## 🧩 Funcionalidades

- 📝 Cadastrar novas receitas com campos personalizados  
- 📄 Listar e visualizar detalhes das receitas salvas  
- ✏️ Editar receitas existentes  
- 📤 Compartilhar receitas em formato PDF  
- 📷 Adicionar imagens a partir da galeria ou câmera  

## 🛠️ Tecnologias Utilizadas

Aplicativo construído com **Flutter** e gerenciado por **Dart**. Algumas das principais bibliotecas utilizadas:

| Biblioteca             | Finalidade                                      |
|------------------------|-------------------------------------------------|
| `flutter_svg`          | Exibição de SVGs                               |
| `flutter_quill`        | Editor de texto rico (para o conteúdo das receitas) |
| `sqflite`              | Banco de dados local (SQLite)                  |
| `path_provider`        | Acesso a diretórios do sistema                  |
| `pdf` / `printing`     | Geração e impressão/exportação de PDFs          |
| `screenshot`           | Captura de tela                                |
| `image_picker`         | Seleção de imagens da galeria ou câmera        |

## 📂 Estrutura de Arquivos

O projeto segue a estrutura padrão de um aplicativo Flutter, com os principais ativos em:

- `lib/` – Código principal do app
- `assets/` – Imagens e ícones (como `chef.svg`)
- `pubspec.yaml` – Gerenciamento de dependências

## 🚀 Como Executar

1. Certifique-se de ter o Flutter instalado: [Guia oficial](https://docs.flutter.dev/get-started/install)
2. Clone o repositório:
   ```bash
   git clone https://github.com/Jonathanmoreiraa/meu-livro-de-receitas.git
   cd meu-livro-de-receitas
   ```
3. Instale as dependências:
```bash
flutter pub get
```

4. Execute o app:
```bash
flutter run
```

## 📦 Versão

- **1.0.0+1**
- SDK Dart: `^3.7.2`

---

🧁 Desenvolvido por [Jonathan Moreira](https://github.com/Jonathanmoreiraa) e [Vinícius Pereira](https://github.com/ViniciusPereira03)