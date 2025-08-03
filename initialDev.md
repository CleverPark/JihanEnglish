아래는 대략적인 앱 개발 프로젝트의 예시야.
전반

English Hero - 영어 학습 앱 개발 문서
목차

프로젝트 개요
핵심 기능 (MVP)
화면 설계
데이터 구조
디자인 시스템
기술 스택
프로젝트 구조
개발 계획

1. 프로젝트 개요
   기본 정보

앱 이름: English Hero (영어 용사)
타겟 사용자: 영어를 배우는 어린이
플랫폼: Android (갤럭시 탭 12.4인치 최적화)
개발 도구: Cursor IDE + Claude Code
프레임워크: Flutter + GetX

핵심 가치

게임화된 학습 경험
직관적인 UI/UX
지속적인 동기부여 시스템

2. 핵심 기능 (MVP)
   2.1 사용자 시스템

첫 실행 시 이름 입력
캐릭터 자동 배정
로컬 데이터 저장

2.2 게임 모드

단어 읽기

스와이프로 단어 넘기기
단어당 5 EXP 획득

문장 읽기

스와이프로 문장 넘기기
문장당 10 EXP 획득

문장 순서 맞추기

드래그 앤 드롭으로 순서 정렬
완료 시 30 EXP 획득

2.3 레벨 시스템

레벨 범위: 1-100
20레벨마다 캐릭터 진화
레벨당 필요 경험치: 레벨 × 100

2.4 진도 관리

책별 게임 완료 상태 저장
전체 진행률 표시

3. 화면 설계
   3.1 초기 화면 (사용자 등록)
   ┌─────────────────────────────┐
   │ │
   │ English Hero │
   │ 영어 용사 │
   │ │
   │ ┌─────────────────┐ │
   │ │ 이름 입력... │ │
   │ └─────────────────┘ │
   │ │
   │ [ 시작하기 버튼 ] │
   │ │
   └─────────────────────────────┘

3.2 메인 화면
┌─────────────────────────────┐
│ 이름: 철수 Lv.5 [████──] │
│ │
│ ⚔️ 캐릭터 │
│ │
│ ┌────┐ ┌────┐ ┌────┐ │
│ │책1 │ │책2 │ │책3 │ → │
│ └────┘ └────┘ └────┘ │
└─────────────────────────────┘

3.3 게임 선택 화면
┌─────────────────────────────┐
│ < 뒤로 Hide and Seek │
│ │
│ ┌─────────────────────┐ │
│ │ 📖 게임 1 │ │
│ │ 단어 읽기 │ │
│ └─────────────────────┘ │
│ │
│ ┌─────────────────────┐ │
│ │ 📝 게임 2 │ │
│ │ 문장 읽기 │ │
│ └─────────────────────┘ │
│ │
│ ┌─────────────────────┐ │
│ │ 🔀 게임 3 │ │
│ │ 문장 순서 맞추기 │ │
│ └─────────────────────┘ │
└─────────────────────────────┘

3.4 게임 화면
단어/문장 읽기

┌─────────────────────────────┐
│ (1/8) │
│ │
│ │
│ hide │
│ │
│ │
│ ← 스와이프하세요 → │
│ │
│ [ 완료 ] │
└─────────────────────────────┘

문장 순서 맞추기

┌─────────────────────────────┐
│ 문장을 순서대로 정렬 │
│ │
│ ┌─────────────────────┐ │
│ │ Yes, I can see you. │ │
│ └─────────────────────┘ │
│ │
│ ┌─────────────────────┐ │
│ │ Can you see me? │ │
│ └─────────────────────┘ │
│ │
│ [ 확인하기 ] │
└─────────────────────────────┘

4. 데이터 구조
   /Users/cleverpark/flutter_project/english_hero/lib/bookData/bookData.dart 파일 참조

4.2 사용자 데이터

{
"userName": "철수",
"level": 5,
"currentExp": 250,
"requiredExp": 500,
"characterType": "warrior",
"completedBooks": {
"1": {
"wordGame": true,
"sentenceGame": false,
"orderGame": false
}
},
"lastPlayed": "2024-01-20T10:30:00"
}

4.3 캐릭터 진화 데이터
{
"levels": {
"1-20": {
"title": "견습 용사",
"image": "/Users/cleverpark/flutter_project/english_hero/lib/assets/worriorImg/tempWorrior.png"
},
"21-40": {
"title": "초급 기사",
"image": "/Users/cleverpark/flutter_project/english_hero/lib/assets/worriorImg/tempWorrior.png"
},
"41-60": {
"title": "중급 전사",
"image": "/Users/cleverpark/flutter_project/english_hero/lib/assets/worriorImg/tempWorrior.png"
},
"61-80": {
"title": "상급 마법사",
"image": "/Users/cleverpark/flutter_project/english_hero/lib/assets/worriorImg/tempWorrior.png"
},
"81-100": {
"title": "전설의 영웅",
"image": "/Users/cleverpark/flutter_project/english_hero/lib/assets/worriorImg/tempWorrior.png"
}
}
}

5. 디자인 시스템
   5.1 디자인 컨셉
   "판타지 RPG 스타일의 친근한 학습 환경"

부드럽고 따뜻한 색감
둥글둥글한 UI 요소
게임같은 재미있는 인터페이스

5.2 컬러 팔레트
class AppColors {
// Primary - 하늘색 계열 (모험의 시작)
static const Color primary = Color(0xFF5B9EF7);
static const Color primaryLight = Color(0xFF8FBCFF);
static const Color primaryDark = Color(0xFF3A7FDB);

// Secondary - 따뜻한 주황색 (보상, 성취)
static const Color secondary = Color(0xFFFF8C42);
static const Color secondaryLight = Color(0xFFFFAB73);
static const Color secondaryDark = Color(0xFFE66E1F);

// Success - 밝은 초록 (정답, 레벨업)
static const Color success = Color(0xFF4CAF50);

// Background
static const Color bgPrimary = Color(0xFFF5F7FB);
static const Color bgSecondary = Color(0xFFFFFFFF);

// Text
static const Color textPrimary = Color(0xFF2D3748);
static const Color textSecondary = Color(0xFF718096);

// Card/Surface
static const Color surface = Color(0xFFFFFFFF);
static const Color cardShadow = Color(0x1A000000);
}

5.3 타이포그래피
class AppTextStyles {
// 제목용 - 둥근 느낌의 폰트
static const TextStyle heading1 = TextStyle(
fontFamily: 'NotoSansKR',
fontSize: 32,
fontWeight: FontWeight.w700,
height: 1.3,
);

static const TextStyle heading2 = TextStyle(
fontFamily: 'NotoSansKR',
fontSize: 24,
fontWeight: FontWeight.w600,
);

// 게임 내 텍스트 (태블릿 최적화)
static const TextStyle gameText = TextStyle(
fontFamily: 'NotoSansKR',
fontSize: 48,
fontWeight: FontWeight.w500,
);

// 버튼 텍스트
static const TextStyle button = TextStyle(
fontFamily: 'NotoSansKR',
fontSize: 18,
fontWeight: FontWeight.w600,
);
}

5.4 컴포넌트 스타일
카드 스타일
BoxDecoration cardDecoration = BoxDecoration(
color: AppColors.surface,
borderRadius: BorderRadius.circular(20),
boxShadow: [
BoxShadow(
color: AppColors.cardShadow,
blurRadius: 10,
offset: Offset(0, 4),
),
],
);

버튼 스타일

// 메인 버튼
BoxDecoration primaryButtonDecoration = BoxDecoration(
gradient: LinearGradient(
colors: [AppColors.primary, AppColors.primaryDark],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
borderRadius: BorderRadius.circular(30),
boxShadow: [
BoxShadow(
color: AppColors.primary.withOpacity(0.3),
blurRadius: 8,
offset: Offset(0, 4),
),
],
);

5.5 여백 시스템
class AppSpacing {
static const double xs = 8.0;
static const double sm = 16.0;
static const double md = 24.0;
static const double lg = 32.0;
static const double xl = 48.0;
}

6. 기술 스택
   프레임워크 & 라이브러리

dependencies:
flutter:
sdk: flutter

# 상태관리

get: ^4.6.6

# 로컬 저장소

get_storage: ^2.1.1

# 애니메이션

lottie: ^2.7.0
flutter_animate: ^4.3.0

# UI 컴포넌트

flutter_screenutil: ^5.9.0
google_fonts: ^6.1.0

# 제스처

flutter_draggable_gridview: ^0.0.7

7. 프로젝트 구조

english_hero/
├── lib/
│ ├── app/
│ │ ├── core/
│ │ │ ├── theme/
│ │ │ │ ├── app_colors.dart
│ │ │ │ ├── app_text_styles.dart
│ │ │ │ └── app_theme.dart
│ │ │ ├── values/
│ │ │ │ ├── app_spacing.dart
│ │ │ │ └── app_constants.dart
│ │ │ └── utils/
│ │ │ ├── level_system.dart
│ │ │ └── storage_service.dart
│ │ ├── data/
│ │ │ ├── models/
│ │ │ │ ├── book_model.dart
│ │ │ │ ├── user_model.dart
│ │ │ │ └── character_model.dart
│ │ │ └── providers/
│ │ │ └── book_provider.dart
│ │ ├── modules/
│ │ │ ├── welcome/
│ │ │ │ ├── bindings/welcome_binding.dart
│ │ │ │ ├── controllers/welcome_controller.dart
│ │ │ │ └── views/welcome_view.dart
│ │ │ ├── home/
│ │ │ │ ├── bindings/home_binding.dart
│ │ │ │ ├── controllers/home_controller.dart
│ │ │ │ └── views/home_view.dart
│ │ │ ├── game_menu/
│ │ │ │ └── ...
│ │ │ ├── word_game/
│ │ │ │ └── ...
│ │ │ ├── sentence_game/
│ │ │ │ └── ...
│ │ │ └── order_game/
│ │ │ └── ...
│ │ ├── routes/
│ │ │ ├── app_pages.dart
│ │ │ └── app_routes.dart
│ │ └── widgets/
│ │ ├── character_widget.dart
│ │ ├── level_bar_widget.dart
│ │ └── game_card_widget.dart
│ └── main.dart
├── assets/
│ ├── images/
│ │ ├── characters/
│ │ └── icons/
│ ├── animations/
│ └── data/
│ └── books.json
└── pubspec.yaml

개발 시 참고사항
GetX 컨트롤러 예시
class HomeController extends GetxController {
final RxInt userLevel = 1.obs;
final RxInt currentExp = 0.obs;
final RxString userName = ''.obs;

void addExperience(int exp) {
currentExp.value += exp;
checkLevelUp();
}

void checkLevelUp() {
int requiredExp = userLevel.value \* 100;
if (currentExp.value >= requiredExp) {
userLevel.value++;
currentExp.value -= requiredExp;
showLevelUpAnimation();
}
}
}

로컬 저장소 사용
class StorageService extends GetxService {
late GetStorage box;

Future<StorageService> init() async {
await GetStorage.init();
box = GetStorage();
return this;
}

void saveUserData(UserModel user) {
box.write('user', user.toJson());
}

UserModel? getUserData() {
final data = box.read('user');
return data != null ? UserModel.fromJson(data) : null;
}
}
