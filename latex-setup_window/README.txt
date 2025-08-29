README - LaTeX + Inkscape Workflow Setup
===========================================

이 저장소(dotfiles-latex)는 VS Code + LaTeX + Inkscape 환경을 빠르게 설정하고,
그림을 원큐에 삽입할 수 있는 워크플로우를 제공합니다.

-------------------------------------------
1. 설치 방법 (새 PC에서 최초 1회)
-------------------------------------------

1) zip 압축 풀기 (dotfiles-latex.zip)
   원하는 위치(예: 바탕화면)에서 압축을 풉니다.

2) PowerShell 실행
   압축 푼 폴더 안에서 마우스 오른쪽 클릭 → "터미널에서 열기"

3) 실행 정책 허용 (최초 1회만)
   PowerShell에 아래 명령 입력:
     Set-ExecutionPolicy -Scope CurrentUser RemoteSigned

4) 설치 스크립트 실행
     .\install.ps1

5) VS Code 재시작

※ 설치 스크립트가 하는 일
- VS Code 설정/키바인딩/태스크/스니펫 배포
- figure_workflow.ps1 스크립트를 tex-tools 폴더에 설치
- mystyle.sty를 TEXMFHOME에 설치
- PATH에 tex-tools 추가
- MiKTeX filename database 갱신
- LaTeX Workshop 확장 자동 설치

-------------------------------------------
2. 사용 방법
-------------------------------------------

LaTeX 문서 시작 부분에:
    \usepackage{mystyle}

그림 삽입 워크플로우:
1) VS Code에서 **Ctrl+Shift+I** 누름
   → 그림 이름 입력 (예: omega)
   → Inkscape 창 열림

2) Inkscape에서 그림을 그리고 저장(Ctrl+S) 후 닫음

3) 자동으로 PDF+LaTeX 내보내기 실행됨

4) VS Code 에디터로 돌아와서 **Ctrl+V**
   → figure 블록이 자동 삽입됨

   예시:
   \begin{figure}[H]
   \centering
   \def\svgwidth{0.35\linewidth}
   \import{figures/omega/}{omega.pdf_tex}
   \caption{omega}\label{fig:omega}
   \end{figure}

-------------------------------------------
3. 추가 기능
-------------------------------------------

- 스니펫(figi):
  `figi` 입력 후 Tab →
    \figinclude{name}{caption}{0.35}
  한 줄로 그림 삽입 가능

- mystyle.sty:
  자주 쓰는 패키지(import, float, amsmath 등)와 정리 환경(theorem, lemma 등),
  \figinclude 매크로 정의 포함.

-------------------------------------------
4. 확인 방법
-------------------------------------------

- PowerShell에서:
  kpsewhich mystyle.sty
  → mystyle.sty 경로가 나오면 OK

- LaTeX 문서에서:
  \usepackage{mystyle}
  컴파일 시 에러가 없으면 OK

-------------------------------------------
5. 주의사항
-------------------------------------------

- 반드시 Inkscape가 설치되어 있어야 합니다.
- PATH에 tex-tools가 추가되었는지 확인하세요.
- VS Code/터미널은 설치 후 재시작해야 변경사항이 적용됩니다.
- figure 삽입 후 캡션 내용은 꼭 수정해 주세요.

-------------------------------------------
끝.
