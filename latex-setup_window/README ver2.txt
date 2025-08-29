LaTeX + Inkscape + VS Code Workflow 사용설명서
=================================================

이 문서는 VS Code에서 LaTeX 작업을 할 때 Inkscape 그림을 빠르게 삽입할 수 있도록
설치, 사용, 백업, 복구 방법을 모두 정리한 통합 안내서입니다.

-------------------------------------------------
1. 설치 방법 (새 PC에서 최초 1회)
-------------------------------------------------

1) dotfiles-latex.zip 압축을 풉니다.

2) PowerShell을 열고 (관리자 아님), 압축 푼 폴더로 이동합니다.

3) 실행 정책 허용 (최초 1회만 필요):
    Set-ExecutionPolicy -Scope CurrentUser RemoteSigned

4) 설치 스크립트 실행:
    .\install.ps1

5) VS Code 재시작

설치 스크립트가 하는 일:
- VS Code 설정(settings.json), 키바인딩(keybindings.json), 태스크(tasks.json), 스니펫(snippets)을 설치
- figure_workflow.ps1 스크립트를 C:\Users\<이름>\tex-tools\ 에 설치
- mystyle.sty를 C:\Users\<이름>\texmf\tex\latex\mystyle\ 에 설치
- PATH에 tex-tools 추가
- MiKTeX 파일명 데이터베이스 갱신
- LaTeX Workshop 확장 자동 설치

-------------------------------------------------
2. 사용 방법
-------------------------------------------------

1) LaTeX 문서 시작 부분에 다음을 추가합니다:
    \usepackage{mystyle}

2) 그림 삽입 워크플로우:
   - VS Code에서 Ctrl+Shift+I → 그림 이름 입력 → Inkscape 창 열림
   - Inkscape에서 그림을 그린 후 저장(Ctrl+S)하고 닫기
   - 자동으로 PDF+LaTeX 내보내기 실행됨
   - VS Code 에디터로 돌아와서 Ctrl+V → figure 블록 자동 삽입

   예시:
   \begin{figure}[H]
   \centering
   \def\svgwidth{0.35\linewidth}
   \import{figures/omega/}{omega.pdf_tex}
   \caption{omega}\label{fig:omega}
   \end{figure}

3) 추가 기능:
   - 스니펫(figi): `figi` 입력 후 Tab → \figinclude{name}{caption}{0.35}
   - mystyle.sty: 자주 쓰는 패키지(import, float, amsmath 등)와 정리 환경(theorem 등),
     \figinclude 매크로 정의 포함

-------------------------------------------------
3. 백업 방법
-------------------------------------------------

백업은 backup.ps1 스크립트로 자동화됩니다.

1) backup.ps1를 원하는 위치에 두고 PowerShell에서 실행:
    .\backup.ps1

2) 바탕화면에 zip 파일 생성:
    latex-setup-backup-YYYYMMDD-HHMM.zip

백업에 포함되는 것:
- VS Code 사용자 설정 (settings.json, keybindings.json, tasks.json, snippets/)
- tex-tools 폴더 (figure_workflow.ps1 등)
- 개인 TEXMF 스타일 (mystyle.sty 등)
- 설치된 VS Code 확장 목록 (extensions.txt)
- 기본 정보(info.txt)

-------------------------------------------------
4. 복구 방법 (새 PC에서)
-------------------------------------------------

1) dotfiles-latex.zip 혹은 백업 zip 파일을 복사하여 압축 풉니다.

2) PowerShell에서 해당 폴더로 이동 후:
    .\install.ps1

3) VS Code 재시작

※ 폴더 이름은 꼭 dotfiles-latex일 필요 없습니다.
   install.ps1는 현재 실행되는 위치($Here)를 기준으로 동작하기 때문에
   폴더 이름은 자유롭게 정해도 됩니다.

-------------------------------------------------
5. 확인 방법
-------------------------------------------------

- PowerShell에서:
    kpsewhich mystyle.sty
  → mystyle.sty 경로가 출력되면 OK

- VS Code에서:
    Ctrl+Shift+I → 그림 그리기 → 저장/닫기 → Ctrl+V
  → figure 블록이 삽입되면 OK

-------------------------------------------------
끝.
