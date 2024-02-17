import 'package:flutter/material.dart';
import 'package:earlips/viewModels/home/home_viewmodel.dart';
import 'package:earlips/views/base/base_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:earlips/views/home/widget/study_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
//dart.ui
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:earlips/views/script/learning_session_screen.dart';
import '../realtime/real_create_script_screen.dart';

class HomeScreen extends BaseScreen<HomeViewModel> {
  const HomeScreen({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        top: true,
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            final bool isLoggedIn = snapshot.hasData;
            return SingleChildScrollView(
              child: Column(
                children: [
                  const _Header(),
                  const _Top(),
                  const _Middle(),
                  // 로그인 상태에 따라 _Bottom 클래스의 컨테이너 색상을 변경
                  _Bottom(isLoggedIn: isLoggedIn),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          //왼쪽으로 정렬
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 20.0, top: 20.0),

          child: const Text(
            "오늘도 열심히 해볼까요?",
            style: TextStyle(
              fontFamily: 'Pretendard-Bold',
              fontSize: 25,
              //weight
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Row의 크기를 내용물에 맞게 조정
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8.0), // 점과 텍스트 사이의 간격 조정
                height: 10.0, // 점의 높이
                width: 10.0, // 점의 너비
                decoration: const BoxDecoration(
                  color: Colors.green, // 점의 색상을 초록색으로 설정
                  shape: BoxShape.circle, // 원형으로 점을 만듭니다
                ),
              ),
              const Text(
                "korean - Bunju",
                style: TextStyle(
                  fontFamily: 'Pretendard-Regular',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _Top extends StatelessWidget {
  const _Top({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      margin: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(30.0),
      ),
      height: Get.height * 0.19,
      child: const Row(children: [
        _Circle(),
        _SpeakingAbility(),
      ]),
    ));
  }
}

class _Middle extends StatelessWidget {
  const _Middle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      InkWell(
        onTap: () {
          Get.to(() => LearningSessionScreen());
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20.0),
          height: Get.height * 0.21,
          width: Get.width * 0.43,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                width: 90,
                height: 90,
                child: Image.asset('assets/images/home/Chart_new.png'),
              ),
              const Text(
                "대본으로 학습하기",
                style: TextStyle(
                  fontFamily: 'Pretendard-Bold',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "대본 입력 및 발음 테스트",
                style: TextStyle(
                  fontFamily: 'Pretendard-Regular',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Get.to(() =>
              RealCreateScriptPage()); // Adjust the screen name as necessary
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20.0),
          height: Get.height * 0.21,
          width: Get.width * 0.43,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: SvgPicture.asset(
                  'assets/images/home/three_circle.svg',
                  width: 85,
                  height: 85,
                ),
              ),
              const Text(
                "실시간 발음테스트",
                style: TextStyle(
                  fontFamily: 'Pretendard-Bold',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "음성 인식 및 발음 테스트",
                style: TextStyle(
                  fontFamily: 'Pretendard-Regular',
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}

class _Bottom extends StatelessWidget {
  final bool isLoggedIn;
  const _Bottom({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF), // 기본 배경색
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20.0, left: 20.0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "진행한 학습",
                  style: TextStyle(
                    fontFamily: 'Pretendard-Bold',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const LineChartSample2(),
            ],
          ),
        ),
        if (!isLoggedIn) // 로그인 안 됐을 때만 블러 효과와 자물쇠 아이콘 표시
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.1),
                  child: Icon(
                    Icons.lock_outline,
                    size: 60,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({super.key});

  @override
  Widget build(BuildContext context) {
    // HomeViewModel 인스턴스 접근
    final homeViewModel = Get.find<HomeViewModel>();

    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(left: 20.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/home/circle.svg',
            width: 90,
            height: 90,
          ),
          Obx(() => Text(
                homeViewModel.circleNumber.toString(), // Observable 값을 사용
                style: const TextStyle(
                  fontFamily: 'Pretendard-Bold',
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              )),
        ],
      ),
    );
  }
}

class _SpeakingAbility extends StatelessWidget {
  const _SpeakingAbility({super.key});

  @override
  Widget build(BuildContext context) {
    // HomeViewModel 인스턴스 접근
    final homeViewModel = Get.find<HomeViewModel>();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 35.0, right: 25.0, left: 40.0),
          child: const Text(
            "Speaking Ability",
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Pretendard-Bold',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8.0, right: 25.0, left: 40.0),
          child: Row(
            children: [
              Obx(() => Text(
                    "발음 ${homeViewModel.speakingScore}",
                    style: const TextStyle(
                      fontFamily: 'Pretendard-Regular',
                      fontSize: 15,
                    ),
                  )),
              const SizedBox(width: 30),
              Obx(() => Text(
                    "높낮이 ${homeViewModel.pitchScore}",
                    style: const TextStyle(
                      fontFamily: 'Pretendard-Regular',
                      fontSize: 15,
                    ),
                  )),
            ],
          ),
        ),
        Obx(
          () => Container(
            margin: const EdgeInsets.only(top: 20.0, left: 20.0),
            child: LinearPercentIndicator(
              barRadius: const Radius.circular(10.0),
              width: 163.0,
              lineHeight: 8.0,
              percent: homeViewModel.linialPersent.value,
              progressColor: const Color(0xFF4EC040),
            ),
          ),
        )
      ],
    );
  }
}
