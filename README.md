# LaTeX + Inkscape Workflow Setup ![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS-blue) ![VSCode](https://img.shields.io/badge/editor-VS%20Code-orange) ![LaTeX](https://img.shields.io/badge/latex-amsmath%2Famsthm-green)

VS Code + LaTeX + Inkscape 환경에서  
**그림을 원큐에 삽입**하는 워크플로우를 Windows와 macOS 모두 지원합니다 🚀

---

## 📌 기능
- **Ctrl+Shift+I** → 그림 이름 입력 → Inkscape 열림  
- 그림 저장 후 종료 → 자동으로 PDF+LaTeX 내보내기  
- VS Code로 돌아와 **Ctrl+V** → figure 블록 자동 삽입  
- `mystyle.sty` 개인 패키지: 정리 환경 + `\figinclude` 매크로 제공  
- `backup.ps1`으로 VS Code 설정, tex-tools, 개인 스타일, 확장 목록까지 ZIP 백업  

---

## 📂 구조(window)
latex-setup_window/ \\
├─ install.ps1                     # 최초 설치 스크립트\\
├─ backup.ps1                      # 전체 환경 백업 스크립트\\
├─ extensions.txt                  # 필수 VS Code 확장 목록\\
├─ README.md                       # (여기 readme 읽으면 필요 없음)\\
├─ vscode/ \\
│ ├─ settings.json                 # 기본 설정
│ ├─ keybindings.json              # Ctrl+Shift+I 단축키
│ ├─ tasks.json                    # figure:oneshot 태스크
│ └─ snippets/latex.json           # figi 스니펫
├─ tex-tools/
│ └─ figure_workflow.ps1           # Inkscape → Export → 클립보드
└─ texmf/
   └─ tex/latex/mystyle/
      └─ mystyle.sty               # 전역 개인 스타일 패키지

## 📂 구조(mac)
```
latex-setup_mac/
├── install_mac.sh      # 맥 전용 설치 스크립트
├── README_mac.md       # 맥 전용 사용 안내
├── vscode/
│   ├── settings.json
│   ├── keybindings.json   # Cmd+Shift+I → figure:oneshot
│   ├── tasks.json         # 사용자 태스크 (figure:oneshot)
│   └── snippets/latex.json # figi 스니펫 (\figinclude)
├── tex-tools/
│   └── figure_workflow.sh # Inkscape → Export → 클립보드
├── texmf/
│   └── tex/latex/mystyle/
│       └── mystyle.sty    # 개인 패키지 (정리/매크로/figinclude)
```

---

## 📦 Prerequisites (처음 PC 세팅 시 설치해야 할 프로그램)

새로운 PC에서 `install.ps1`, `install_mac.sh`을 실행하기 전에 아래 프로그램들을 반드시 설치해야 합니다.

1. **Visual Studio Code**  
   https://code.visualstudio.com/  
   → LaTeX 작성 및 워크플로우 실행용

2-1. ### Windows
- MiKTeX (설치 후 MiKTeX Console → *Packages* → `latexmk` 설치)
- Strawberry Perl (https://strawberryperl.com/)
- Inkscape (https://inkscape.org/release/)

2-2. ### macOS
- MacTeX (TeX Live) — PATH에 `/Library/TeX/texbin` 포함  
  (예: `echo 'export PATH="/Library/TeX/texbin:$PATH"' >> ~/.zshrc && source ~/.zshrc`)
- Inkscape (https://inkscape.org/release/)
- 
3. **Git** (선택)  
   https://git-scm.com/download/win  
   → GitHub에서 저장소를 clone할 때 필요. ZIP 다운로드로 대체 가능

---

## 🚀 설치 방법 (새 PC)

### Windows
'''powershell
cd latex-setup_windows
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
.\install.ps1

### macOS
cd latex-setup_mac
chmod +x install_mac.sh
./install_mac.sh

2. VS Code 재시작

---

🖼️ 사용 방법

1. LaTeX 문서 시작 부분에:
   \usepackage{mystyle}

2. VS Code에서 그림 삽입:

   Windows: Ctrl+Shift+I
   
   macOS: Cmd+Shift+I
   
   그림 이름 입력 → Inkscape 열림 → 저장 후 종료
   
3. VS Code로 돌아와 붙여넣기:
   
   Windows: Ctrl+V
   
   macOS: Cmd+V

  예시.
  \begin{figure}[H]
  \centering
  \def\svgwidth{0.35\linewidth}
  \import{figures/omega/}{omega.pdf_tex}
  \caption{omega}\label{fig:omega}
  \end{figure}

---

🔑 Snippet

   입력: figi → Tab
   
   결과: \figinclude{name}{caption}{0.35}
    
   스니펫은 mystyle.sty 를 수정함으로써 추가해주세요.

---

💾 백업 방법(Windows)

1. PowerShell에서:
   cd latex-setup/windows
  .\backup.ps1

3. 바탕화면에 ZIP 생성: 
  latex-setup-backup-YYYYMMDD-HHMM.zip

4. 포함 내용:

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

✅ 확인(poewrshall)

1. kpsewhich mystyle.sty → 경로가 나오면 패키지 인식 OK

2. latexmk -v → latexmk 동작 확인

3. perl -v (Windows만) → Perl 확인

4. inkscape --version → Inkscape 확인

5. VS Code에서 Ctrl+Shift+I → 그림 저장/닫기 → Ctrl+V → figure 블록 삽입되면 OK

---

🛠️ Troubleshooting

1. File 'mystyle.sty' not found
   
   kpsewhich mystyle.sty 실행 → 출력 없으면 install.ps1 / install_mac.sh 재실행
   
   Windows: initexmf --update-fndb 실행 후 다시 빌드

2. 'perl' is not recognized (Windows)
   
   Strawberry Perl 설치 필요: https://strawberryperl.com/
   
3. latexmk not found
   
   Windows: MiKTeX Console → Packages → latexmk 설치
   
   macOS: PATH에 /Library/TeX/texbin 추가
   
4. Inkscape 실행 안 됨
   
   Windows: C:\Program Files\Inkscape\bin\inkscape.exe 경로 확인
   
   macOS: /Applications/Inkscape.app/Contents/MacOS/inkscape 존재 확인
   
5. VS Code에서 스니펫(figi)이 안 뜸
   
   확인: %APPDATA%\Code\User\snippets\latex.json (Win)
   ~/Library/Application Support/Code/User/snippets/latex.json (Mac)

   언어 모드가 LaTeX 인지 확인 (VS Code 우측 하단)

끝 🎉
