# 🔬 과학 시뮬레이션 실험실 (ScienceLab)

중학교 과학 수업을 위한 인터랙티브 시뮬레이션 모음입니다. 빌드 도구 없이 브라우저에서 HTML 파일을 열기만 하면 동작합니다.

**바로 사용하기:** https://sonyoungguk.github.io/sciencelab/

## 사용 방법

1. 위 링크에 접속하거나, 저장소를 내려받아 `index.html`을 브라우저로 엽니다.
2. 카드를 클릭하면 각 시뮬레이션이 열립니다.

> 일부 시뮬레이션은 CDN(Tailwind 등)을 사용하므로 인터넷 연결이 필요합니다.

## 새 시뮬레이션 추가 방법

시뮬레이션은 수시로 추가할 수 있으며, 항상 Pull Request로 추가합니다.

1. 새 브랜치를 만듭니다.
   ```
   git checkout -b add-<시뮬레이션-이름>
   ```
2. 시뮬레이션 HTML 파일을 `sims/` 폴더에 넣습니다. (자체 완결형 단일 HTML 권장)
3. `index.html` 상단의 `SIMS` 배열에 항목을 추가합니다.
   ```js
   {
       emoji: '🧲',
       title: '시뮬레이션 이름',
       desc: '한두 문장 설명',
       tags: ['물리', '3학년'],
       file: 'sims/파일이름.html'
   },
   ```
4. 커밋 후 푸시하고 PR을 만듭니다.
   ```
   git push -u origin add-<시뮬레이션-이름>
   gh pr create
   ```
5. PR을 검토·머지하면 GitHub Pages에 자동 반영됩니다.

## 기술 스택

순수 HTML, CSS, JavaScript. 빌드 도구와 서버가 필요 없습니다.
