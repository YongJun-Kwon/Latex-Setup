# LaTeX + Inkscape Workflow Setup

VS Code + LaTeX + Inkscape 환경에서 **그림을 원큐에 삽입**할 수 있는 워크플로우 설정 저장소입니다.  
새 PC에서도 `install.ps1` 한 번으로 같은 환경을 재현할 수 있습니다.

---

## 📌 기능
- **Ctrl+Shift+I** → 그림 이름 입력 → Inkscape 열림  
- 그림 저장 후 종료 → 자동으로 PDF+LaTeX 내보내기  
- VS Code로 돌아와 **Ctrl+V** → figure 블록 자동 삽입  
- `mystyle.sty` 개인 패키지: 정리 환경 + `\figinclude` 매크로 제공  
- `backup.ps1`으로 VS Code 설정, tex-tools, 개인 스타일, 확장 목록까지 ZIP 백업  

---

## 📂 구조
latex-setup/
├─ install.ps1 # 최초 설치 스크립트
├─ backup.ps1 # 전체 환경 백업 스크립트
├─ extensions.txt # 필수 VS Code 확장 목록
├─ README.md # (이 파일)
├─ vscode/
│ ├─ settings.json # 기본 설정
│ ├─ keybindings.json # Ctrl+Shift+I 단축키
│ ├─ tasks.json # figure:oneshot 태스크
│ └─ snippets/latex.json # figi 스니펫
├─ tex-tools/
│ └─ figure_workflow.ps1 # Inkscape → Export → 클립보드
└─ texmf/
└─ tex/latex/mystyle/
└─ mystyle.sty # 전역 개인 스타일 패키지

---

## 📦 Prerequisites (처음 PC 세팅 시 설치해야 할 프로그램)

새로운 PC에서 `install.ps1`을 실행하기 전에 아래 프로그램들을 반드시 설치해야 합니다.

1. **Visual Studio Code**  
   https://code.visualstudio.com/  
   → LaTeX 작성 및 워크플로우 실행용

2. **MiKTeX**  
   https://miktex.org/download  
   → LaTeX 배포판 (Windows)  
   설치 후 MiKTeX Console → *Packages* → `latexmk` 검색하여 설치

3. **Perl (Strawberry Perl 권장)**  
   https://strawberryperl.com/  
   → `latexmk`는 Perl로 작성되어 있으므로 Perl 실행 환경이 필요합니다.

4. **Inkscape**  
   https://inkscape.org/release/  
   → 그림 제작 및 `.svg → .pdf_tex` 변환

5. **Git** (선택)  
   https://git-scm.com/download/win  
   → GitHub에서 저장소를 clone할 때 필요. ZIP 다운로드로 대체 가능

---

## 🚀 설치 방법 (새 PC)
1. 저장소 클론:
   ```bash
   git clone https://github.com/<username>/latex-setup.git
   cd latex-setup
2. PowerShell 실행 (관리자 아님)

3. 실행 정책 허용 (최초 1회만): powershell
  Set-ExecutionPolicy -Scope CurrentUser RemoteSigned

4. 설치 스크립트 실행: powershell
  .\install.ps1

5. VS Code 재시작

---

🖼️ 사용 방법

1. LaTeX 문서 시작 부분에:
   \usepackage{mystyle}

2. 그림 삽입:

  Ctrl+Shift+I → 이름 입력 → Inkscape에서 그림 작성 → 저장 후 닫기

  VS Code에서 Ctrl+V → figure 블록 삽입됨

  예시.
  \begin{figure}[H]
  \centering
  \def\svgwidth{0.35\linewidth}
  \import{figures/omega/}{omega.pdf_tex}
  \caption{omega}\label{fig:omega}
  \end{figure}

3. 스니펫 : 스니펫은 mystyle.sty 를 수정함으로써 추가해주세요.

---

💾 백업 방법

1. PowerShell에서:
  .\backup.ps1

2. 바탕화면에 ZIP 생성: 
  latex-setup-backup-YYYYMMDD-HHMM.zip

3. 포함 내용:

  VS Code 설정 (settings/keybindings/tasks/snippets)
  
  tex-tools/
  
  개인 TEXMF 스타일 (mystyle.sty 등)
  
  VS Code 확장 목록 (extensions.txt)
  
  info.txt (환경 정보)

---

🔄 복구 방법

백업 ZIP을 새 PC에 풀고 .\install.ps1 실행

폴더 이름은 자유 (latex-setup, my-env 등 가능)

---

✅ 확인

1. PowerShell에서:
  kpsewhich mystyle.sty
  → 경로가 출력되면 OK

2. VS Code에서 Ctrl+Shift+I → 그림 저장/닫기 → Ctrl+V → figure 블록 삽입되면 OK

끝 🎉
