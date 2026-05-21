# Из Обсидиан в интернет (git, quartz)

Вот полная инструкция — максимально просто, шаг за шагом.

***

## Что тебе понадобится

- Компьютер с macOS (у тебя он есть)
- Аккаунт на **GitHub** (бесплатно) — github.com
- **Node.js** — программа для запуска Quartz
- **Git** — программа для работы с GitHub

***

## Шаг 1 — Установи Node.js и Git

**Node.js:**

1. Зайди на [nodejs.org](https://nodejs.org)
2. Скачай версию **LTS** (зелёная кнопка)
3. Установи как обычную программу

**Git:**

1. Открой **Терминал** (найди через Spotlight: `⌘ + Space`, напиши «Терминал»)
2. Введи команду:

```bash
git --version
```

3. Если Git не установлен — macOS сам предложит его установить, нажми **Install**

***

## Шаг 2 — Зарегистрируйся на GitHub

1. Зайди на [github.com](https://github.com)
2. Нажми **Sign up**, создай аккаунт
3. Запомни своё **имя пользователя** — оно войдёт в адрес твоего сайта

***

## Шаг 3 — Скачай Quartz на компьютер

В Терминале введи команды одну за другой:

```bash
git clone https://github.com/jackyzha0/quartz.git
cd quartz
npm install
npx quartz create
```

На вопросы отвечай так:[^1]

- *Initialize content* → выбери **Empty Quartz**
- *Resolve links* → выбери **Shortest path**

***

## Шаг 4 — Перенеси свои заметки из Obsidian

1. Найди папку `quartz/content/` на компьютере
2. Открой папку своего **хранилища Obsidian** в Finder
3. Скопируй все `.md` файлы и папки из хранилища Obsidian **в папку `quartz/content/`**[^1]

***

## Шаг 5 — Проверь как выглядит сайт локально

В Терминале (убедись, что ты в папке `quartz`):

```bash
npx quartz build --serve
```

Открой браузер и зайди на `http://localhost:8080` — ты увидишь свой сайт. Если всё выглядит нормально — идём дальше.[^1]

***

## Шаг 6 — Создай репозиторий на GitHub

1. Зайди на [github.com](https://github.com) → нажми **New repository** (зелёная кнопка)
2. Назови репозиторий, например `my-wiki`
3. Выбери **Public** (для бесплатного хостинга)
4. Нажми **Create repository**
5. GitHub покажет тебе адрес репозитория — скопируй его (выглядит как `https://github.com/твоё-имя/my-wiki.git`)

***

## Шаг 7 — Залей Quartz на GitHub

В Терминале (ты должен быть в папке `quartz`):

```bash
git remote set-url origin https://github.com/твоё-имя/my-wiki.git
git remote add upstream https://github.com/jackyzha0/quartz.git
git push -u origin v4
```

⚠️ Замени `твоё-имя/my-wiki` на свои данные.[^2]

***

## Шаг 8 — Включи автоматическую публикацию

1. На GitHub зайди в свой репозиторий
2. Нажми **Settings** (вверху справа)
3. В левом меню найди **Pages**
4. В разделе **Build and deployment** → **Source** выбери **GitHub Actions**[^3]

Теперь создай файл автодеплоя. В Терминале:

```bash
mkdir -p .github/workflows
```

Открой любой текстовый редактор, создай файл `.github/workflows/deploy.yml` и вставь туда:[^3]

```yaml
name: Deploy Quartz site to GitHub Pages
on:
  push:
    branches:
      - v4
permissions:
  contents: read
  pages: write
  id-token: write
jobs:
  build:
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - uses: actions/setup-node@v3
        with:
          node-version: 18.14
      - name: Install Dependencies
        run: npm ci
      - name: Build Quartz
        run: npx quartz build
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v2
        with:
          path: public
  deploy:
    needs: build
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v2
```

Сохрани файл и запушь:[^3]

```bash
git add .
git commit -m "add deploy workflow"
git push
```


***

## Шаг 9 — Готово!

Через 1–2 минуты твой сайт будет доступен по адресу:[^2]

```
https://твоё-имя.github.io/my-wiki
```


***

## Как обновлять сайт в будущем

Каждый раз когда добавляешь новые заметки — просто копируй их в папку `content/` и выполняй три команды в Терминале:[^1]

```bash
git add .
git commit -m "обновление заметок"
git push
```

Сайт автоматически пересоберётся через 1–2 минуты.
