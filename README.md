# 개발 환경 설정 스크립트 저장소

이 저장소는 Windows 및 WSL2(Windows Subsystem for Linux 2) 환경에서 개발 환경을 자동으로 설정하고 관리하기 위한 스크립트 모음을 제공합니다.

---

## 1\. 개요

`control.bat` 파일을 통해 사용자 친화적인 메뉴 방식으로 다음 작업을 수행할 수 있습니다. 각 옵션은 특정 개발 환경을 설정하거나 관리하기 위한 전용 스크립트를 실행합니다.

---

## 2\. `control.bat` 메뉴 및 설치/관리 구성 요소 상세

아래는 `control.bat` 메뉴의 각 항목이 실행하는 스크립트와 해당 스크립트가 설치하거나 관리하는 주요 구성 요소에 대한 상세 설명입니다.

---

### 2.1. Windows 개발 환경 설정

**`control.bat` 메뉴 옵션: `1. Setup Windows Dev Environment`**
**실행 스크립트: `scripts/setup-windows.bat`**

이 스크립트는 Windows 운영체제에서 WSL2의 기본 기능을 설정하고 Ubuntu 배포판을 설치합니다.

- **WSL2 (Windows Subsystem for Linux 2)**
  - **설명**: Windows에서 경량 가상 머신을 통해 완전한 Linux 환경을 실행할 수 있게 해주는 기능입니다. Linux 커널을 포함하고 있어 높은 성능과 호환성을 제공합니다.
  - **공식 문서**: [https://docs.microsoft.com/ko-kr/windows/wsl/install](https://docs.microsoft.com/ko-kr/windows/wsl/install)
- **Ubuntu (WSL2 배포판)**
  - **설명**: WSL2의 기본 Linux 배포판으로 가장 널리 사용되는 리눅스 운영체제 중 하나입니다. 안정성과 광범위한 패키지 지원을 제공합니다.
  - **공식 웹사이트**: [https://ubuntu.com/](https://ubuntu.com/)

---

### 2.2. WSL2 (Ubuntu) 개발 환경 설정

**`control.bat` 메뉴 옵션: `2. Setup Linux Dev Environment` 또는 `3. Setup WSL2 Dev Environment`**
**실행 스크립트: `scripts/setup-wsl2-dev-env.sh`**

이 스크립트는 WSL2 내부에 설치된 Ubuntu 환경에 다양한 개발 도구 및 라이브러리를 설치하고 설정합니다.

#### **시스템 유틸리티**

- **`build-essential`**
  - **설명**: C/C++ 컴파일러(GCC, G++) 및 다양한 개발 라이브러리, 헤더 파일 등을 포함하는 패키지 모음입니다. 리눅스에서 소프트웨어 소스를 컴파일하는 데 필수적입니다.
- **`curl`**
  - **설명**: URL 문법을 이용하여 다양한 프로토콜(HTTP, HTTPS, FTP 등)을 통해 데이터를 전송하거나 받는 명령줄 도구입니다. 웹 요청 및 파일 다운로드에 널리 사용됩니다.
  - **공식 문서**: [https://curl.se/docs/](https://curl.se/docs/)
- **`git`**
  - **설명**: 분산 버전 관리 시스템으로, 소스 코드의 변경 이력을 효율적으로 추적하고 여러 개발자 간의 협업을 가능하게 합니다.
  - **공식 문서**: [https://git-scm.com/doc](https://git-scm.com/doc)

#### **쉘 및 생산성 도구**

- **`zsh`**
  - **설명**: Bash 쉘의 확장 버전으로, 자동 완성, 히스토리 관리, 플러그인 지원 등 강력한 기능을 제공하여 터미널 사용 경험을 향상시킵니다.
  - **공식 문서**: [https://zsh.sourceforge.io/Doc/Release/zsh_toc.html](https://zsh.sourceforge.io/Doc/Release/zsh_toc.html)
- **`Oh My Zsh`**
  - **설명**: `zsh` 설정을 쉽게 관리하고 수많은 플러그인과 테마를 적용할 수 있게 해주는 커뮤니티 기반의 프레임워크입니다.
  - **공식 웹사이트**: [https://ohmyz.sh/](https://ohmyz.sh/)
- **`zsh-syntax-highlighting`**
  - **설명**: `zsh` 쉘에서 입력하는 명령어의 구문을 실시간으로 강조하여 가독성을 높이고 오타를 줄이는 데 도움을 줍니다.
  - **GitHub**: [https://github.com/zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- **`zsh-autosuggestions`**
  - **설명**: `zsh` 쉘에서 이전에 입력했던 명령어를 기반으로 자동 완성 추천을 제공하여 명령 입력을 빠르게 해줍니다.
  - **GitHub**: [https://github.com/zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- **`tmux`**
  - **설명**: 터미널 멀티플렉서로, 단일 터미널 창에서 여러 개의 가상 터미널 세션을 생성, 관리하고 백그라운드에서 실행할 수 있게 합니다. SSH 연결이 끊어져도 세션이 유지됩니다.
  - **GitHub Wiki**: [https://github.com/tmux/tmux/wiki](https://github.com/tmux/tmux/wiki)
- **`fzf`**
  - **설명**: 명령줄에서 파일, 디렉토리, 명령어 히스토리 등을 빠르고 효율적으로 찾을 수 있는 강력한 퍼지 파인더(fuzzy finder)입니다.
  - **GitHub**: [https://github.com/junegunn/fzf](https://github.com/junegunn/fzf)
- **`zoxide`**
  - **설명**: 기존 `cd` 명령을 대체하여 자주 방문하는 디렉토리나 최근 방문한 디렉토리로 짧은 명령어를 통해 빠르게 이동할 수 있게 해주는 도구입니다.
  - **GitHub**: [https://github.com/ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide)
- **`direnv`**
  - **설명**: 특정 디렉토리로 이동할 때 자동으로 해당 디렉토리 내 `.envrc` 파일에 정의된 환경 변수를 로드하고, 디렉토리를 벗어나면 언로드하는 도구입니다. 프로젝트별 환경 관리에 유용합니다.
  - **공식 웹사이트**: [https://direnv.net/](https://direnv.net/)

#### **컨테이너 도구**

- **Docker Engine, containerd, Docker Buildx Plugin, Docker Compose Plugin**
  - **설명**: 컨테이너화된 애플리케이션을 개발, 배포, 실행하기 위한 오픈 소스 플랫폼입니다. **WSL2 배포판 내부에 직접 설치**되어 리눅스 환경과 동일하게 동작합니다. `docker-compose-plugin`을 통해 Docker Compose v2 기능을 사용할 수 있습니다.
  - **공식 문서**: [https://docs.docker.com/](https://docs.docker.com/)

#### **Node.js 생태계**

- **`nvm (Node Version Manager)`**
  - **설명**: 여러 Node.js 버전을 시스템에 설치하고 필요에 따라 쉽게 전환하여 사용할 수 있게 해주는 도구입니다. 프로젝트별로 다른 Node.js 버전을 사용할 때 유용합니다.
  - **GitHub**: [https://github.com/nvm-sh/nvm](https://github.com/nvm-sh/nvm)
- **`Node.js (LTS 버전)`**
  - **설명**: nvm을 통해 최신 LTS(Long Term Support) 버전이 설치됩니다. LTS 버전은 장기적인 안정성을 보장하여 프로덕션 환경에 권장됩니다.
  - **공식 문서**: [https://nodejs.org/ko/docs/](https://nodejs.org/ko/docs/)
- **`npm (Node Package Manager)`**
  - **설명**: Node.js 환경에서 패키지(라이브러리)를 설치, 관리, 공유하는 데 사용되는 기본 패키지 관리자입니다. Node.js 설치 시 함께 제공됩니다.
  - **공식 문서**: [https://docs.npmjs.com/](https://docs.npmjs.com/)
- **`yarn`**
  - **설명**: `npm`과 유사한 Node.js 패키지 관리자로, 의존성 설치 속도가 빠르고 의존성 트리를 안정적으로 관리하는 데 강점이 있습니다.
  - **공식 웹사이트**: [https://yarnpkg.com/](https://yarnpkg.com/)
- **`typescript`**
  - **설명**: JavaScript에 정적 타입 기능을 추가하여 대규모 애플리케이션 개발에 적합한 언어입니다. 코드의 안정성과 가독성을 높여줍니다.
  - **공식 문서**: [https://www.typescriptlang.org/docs/](https://www.typescriptlang.org/docs/)

#### **Rust 프로그래밍 언어**

- **`rustup`**
  - **설명**: Rust 프로그래밍 언어의 공식 설치 관리자이자 버전 관리 도구입니다. Rust 컴파일러(`rustc`)와 빌드 시스템/패키지 관리자(`cargo`)를 함께 설치하고 관리합니다.
- **`cargo`**
  - **설명**: Rust 프로젝트의 빌드 시스템이자 패키지 관리자입니다. 의존성 관리, 코드 컴파일, 테스트 실행 등을 담당합니다.
- **`rustc`**
  - **설명**: Rust 소스 코드를 실행 가능한 바이너리로 컴파일하는 Rust 공식 컴파일러입니다.
  - **공식 웹사이트**: [https://www.rust-lang.org/learn](https://www.rust-lang.org/learn)

---

### 2.3. 환경 초기화 및 제거

- **`control.bat` 메뉴 옵션: `4. Reset Linux Dev Environment`**
  - **실행 스크립트**: `scripts/reset-linux-dev.sh`
  - **설명**: WSL2 내의 Linux 개발 환경을 초기 상태로 되돌리거나 주요 설정 파일을 정리하는 데 사용됩니다. (이 스크립트의 상세 내용은 별도로 정의되어야 합니다.)
- **`control.bat` 메뉴 옵션: `5. Run Windows Temp Uninstall Script`**
  - **실행 스크립트**: `scripts/temp_uninstall.bat`
  - **설명**: Windows 환경에서 임시로 설정된 개발 관련 요소들을 제거하거나 비활성화하는 데 사용됩니다. (이 스크립트의 상세 내용은 별도로 정의되어야 합니다.)
- **`control.bat` 메뉴 옵션: `6. Uninstall Windows Environment`**
  - **실행 스크립트**: `scripts/uninstall-windows.bat`
  - **설명**: Windows에 설치된 WSL2 및 관련 구성 요소들을 완전히 제거하는 데 사용됩니다. (이 스크립트의 상세 내용은 별도로 정의되어야 합니다.)

---

### 2.4. 캐시 관리

- **`control.bat` 메뉴 옵션: `7. Clear temp_archive Cache`**
  - **설명**: 스크립트 실행 중 다운로드된 임시 파일이나 아카이브 파일이 저장된 `temp_archive` 폴더를 삭제하여 디스크 공간을 확보합니다.

---

## 3\. 사용 방법

1.  **관리자 권한으로 `control.bat` 실행**:
    `control.bat` 파일을 마우스 오른쪽 버튼으로 클릭한 후 \*\*"관리자 권한으로 실행"\*\*을 선택합니다.
2.  **메뉴 선택**:
    표시되는 메뉴에서 원하는 옵션에 해당하는 숫자를 입력하고 `Enter` 키를 누르면 해당 설정 또는 관리 스크립트가 실행됩니다.

---

## 4\. 설치 후 권장 사항

성공적인 설치 후, 원활한 개발을 위해 다음 사항들을 추가로 설정하는 것을 권장합니다.

- **Git 사용자 정보 설정**:
  스크립트 완료 후, Git 커밋에 사용될 사용자 이름과 이메일을 설정해야 합니다.
  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "your.email@example.com"
  ```
- **Powerlevel10k (선택 사항)**:
  Zsh 쉘의 프롬프트를 더욱 강력하고 시각적으로 멋지게 꾸며주는 Powerlevel10k 테마를 사용하려면 별도로 설치 및 구성해야 합니다.
  - **GitHub**: [https://github.com/romkatv/powerlevel10k\#oh-my-zsh](https://github.com/romkatv/powerlevel10k#oh-my-zsh)
- **direnv 사용**:
  `direnv`를 사용하는 각 프로젝트 디렉토리에서는 해당 프로젝트의 환경 변수를 자동으로 로드하기 위해 `direnv allow` 명령을 한 번 실행해야 합니다.
- **VS Code Remote - WSL 확장**:
  Visual Studio Code를 주력 IDE로 사용하는 경우, VS Code 마켓플레이스에서 **"Remote - WSL"** 확장을 설치하여 Windows의 VS Code에서 WSL2 환경의 프로젝트를 직접 열고, Linux 터미널, 디버거 등을 사용할 수 있습니다.
- **Docker**:
  Docker Engine은 이제 WSL2 배포판 내부에 설치됩니다. 스크립트 실행 후 **반드시 WSL2 터미널을 완전히 닫고 다시 열어** `docker` 그룹에 추가된 사용자 권한을 적용해야 합니다. 이후 `docker run hello-world` 명령으로 Docker가 정상 작동하는지 확인해 보세요.

## 새롭게 설정된 WSL2 개발 환경에서 즐거운 개발 되시길 바랍니다\!
