# 09. Tech Stack

## 플랫폼

| 항목 | 선택 | 이유 |
|------|------|------|
| 런타임 | .NET 8 LTS | 최신 LTS, WPF 지원, 성능 |
| 언어 | C# 12 | 모던 문법 (primary constructor, collection expressions) |
| UI 프레임워크 | WPF | Windows 전용, XAML 성숙도, 기존 RadiConsole 경험 |
| 빌드 | MSBuild + SDK-style | 기본 dotnet CLI 호환 |
| 패키지 관리 | Central Package Management | `Directory.Packages.props` 단일 버전 관리 |

## 핵심 NuGet 패키지

### Core / Analysis
| 패키지 | 버전 | 용도 | 도입 레벨 |
|--------|------|------|----------|
| `PeNet` | 4.0.4+ | PE 파일 파싱 | L1 |
| `ICSharpCode.Decompiler` | 9.0.0+ | C# 디컴파일 | L2 |

### CLI
| 패키지 | 버전 | 용도 | 도입 레벨 |
|--------|------|------|----------|
| `System.CommandLine` | 2.0.0-beta4+ | 인자 파싱 | L1 |
| `Spectre.Console` | 0.49+ | 콘솔 출력 포매팅 (선택) | L1 |

### WPF / MVVM
| 패키지 | 버전 | 용도 | 도입 레벨 |
|--------|------|------|----------|
| `CommunityToolkit.Mvvm` | 8.3+ | MVVM 헬퍼 (`ObservableProperty`, `RelayCommand`) | L2 |
| `Microsoft.Extensions.DependencyInjection` | 8.0+ | DI 컨테이너 | L2 |
| `Microsoft.Extensions.Hosting` | 8.0+ | DI + 로깅 통합 | L2 |
| `AutomaticGraphLayout.WpfGraphControl` | 1.1.12+ | 그래프 시각화 | L3 |

### Export
| 패키지 | 버전 | 용도 | 도입 레벨 |
|--------|------|------|----------|
| `System.Text.Json` | (BCL) | JSON 직렬화 | L1 |
| `Markdig` | 0.37+ | Markdown 생성 | L5 |
| `DocumentFormat.OpenXml` | 3.0+ | Word 내보내기 (선택) | L5 |

### Test
| 패키지 | 버전 | 용도 |
|--------|------|------|
| `xunit` | 2.9+ | 테스트 프레임워크 |
| `xunit.runner.visualstudio` | 2.8+ | VS 통합 |
| `FluentAssertions` | 6.12+ | Assertion DSL |
| `Moq` | 4.20+ | Mocking |
| `coverlet.collector` | 6.0+ | 커버리지 수집 |

---

## 외부 도구 (번들링)

### L4 이상에서 필요

| 도구 | 버전 | 배포 방식 | 경로 |
|------|------|----------|------|
| Ghidra | 11.x | 설치 요구 또는 Tools/ 포함 | `Tools/ghidra/` |
| dumpbin.exe | VS2022 BuildTools | 자동 탐지 | `Program Files/.../MSVC/.../bin/` |

**참고**: Ghidra 전체(~400MB) 번들링은 앱 크기 문제. L4 착수 시 다음 옵션 중 선택:
- A. 사용자 설치 경로 수동 지정
- B. 별도 설치 스크립트 제공
- C. Chocolatey/Scoop 통한 설치 권장

---

## 개발 환경

### 필수
- Windows 10/11 x64
- Visual Studio 2022 (Community 이상)
- .NET 8 SDK
- Git for Windows

### 권장
- GitHub CLI (`gh`) — 이슈 관리 자동화
- PowerShell 7+ — 빌드 스크립트
- JetBrains Rider 또는 VS 2022 (편집기 선택)

### 선택 (L4+)
- Ghidra 11.x
- Java JDK 17+
- API Monitor v2 (수동 동작 검증용)

---

## 빌드 출력

### Debug
- `bin/Debug/net8.0/RevEngStudio.Cli.exe`
- `bin/Debug/net8.0-windows/RevEngStudio.Wpf.exe`

### Release (CI)
- Self-contained single-file publish
- `win-x64` RID
- ReadyToRun 활성화
- Trim 비활성화 (Reflection 사용 충돌 방지)

```xml
<PropertyGroup>
  <RuntimeIdentifier>win-x64</RuntimeIdentifier>
  <PublishSingleFile>true</PublishSingleFile>
  <SelfContained>true</SelfContained>
  <PublishReadyToRun>true</PublishReadyToRun>
  <PublishTrimmed>false</PublishTrimmed>
  <IncludeNativeLibrariesForSelfExtract>true</IncludeNativeLibrariesForSelfExtract>
</PropertyGroup>
```

---

## 코드 분석기

### 활성화
- `Microsoft.CodeAnalysis.NetAnalyzers` (기본 내장)
- `<AnalysisLevel>latest</AnalysisLevel>`
- `<TreatWarningsAsErrors>true</TreatWarningsAsErrors>` (Release만)
- `<Nullable>enable</Nullable>`

### 선택 패키지
- `StyleCop.Analyzers` — 스타일 검증
- `SonarAnalyzer.CSharp` — 추가 품질 분석

---

## 코드 컨벤션

- `.editorconfig` 기반
- `dotnet format` CI 체크
- 파일 헤더 불필요
- `var` 적극 사용
- Primary constructor 선호 (레코드, 간단한 서비스)
- File-scoped namespace 필수

---

## 라이선스 고려사항

| 패키지 | 라이선스 | 상업 이용 |
|--------|---------|-----------|
| PeNet | MIT | 가능 |
| ICSharpCode.Decompiler | MIT | 가능 |
| Ghidra | Apache 2.0 | 가능 (외부 도구) |
| MSAGL | MIT | 가능 |
| Markdig | BSD-2 | 가능 |

모두 개인 프로젝트에 문제 없음.
