import 'package:earlips/utilities/style/color_styles.dart';
import 'package:earlips/viewModels/word/word_viewmodel.dart';
import 'package:earlips/views/word/widget/blue_back_appbar.dart';
import 'package:earlips/views/word/widget/word_list_widget.dart';
import 'package:earlips/views/word/widget/word_sentence_widget.dart';
import 'package:earlips/views/word/widget/word_youtube_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:earlips/views/paragraph/create_script_screen.dart';
import 'package:earlips/views/paragraph/learning_session_screen.dart';

class WordScreen extends StatelessWidget {
  final String title;
  final int type;

  const WordScreen({super.key, required this.title, required this.type});
  @override
  Widget build(BuildContext context) {
    final wordViewModel = Get.put(WordViewModel(
      type: type,
    ));

    final PageController pageController =
        PageController(initialPage: wordViewModel.currentIndex.value);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlueBackAppbar(title: title),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: ColorSystem.main2,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GetBuilder<WordViewModel>(
                    // Add GetBuilder here
                    builder: (controller) => WordList(
                      // viewmodel
                      wordDataList: controller.wordList,
                      type: type,
                      pageController: pageController,
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "아래의 혀, 입술 모양을 따라 말해보세요!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ColorSystem.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // wordViewModel   final String video로 영상 유튜브 링크를 바로 볼 수 있게 하기
            GetBuilder<WordViewModel>(
              builder: (controller) {
                if (controller.type < 2) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: YoutubeWordPlayer(),
                  );
                } else if (controller.type == 2) {
                  return WordSentenceWidget(
                    wordDataList: controller.wordList,
                  );
                } else {
                  return LearningSessionScreen();
                }
              },
            ),
            const Spacer(),
            // final String video로 영상 유튜브 링크를 바로 볼 수 있게 하기
            ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.fromLTRB(30, 10, 30, 10),
                ),
                backgroundColor: MaterialStateProperty.all(ColorSystem.main2),
              ),
              onPressed: () async {
                // isLast
                Get.dialog(
                  AlertDialog(
                    title: const Text('학습 완료'),
                    content: const Text('다음으로 넘어가려면 아래 버튼을 눌러주세요.'),
                    actions: [
                      ElevatedButton(
                        // button style
                        onPressed: () async {
                          // 단어 학습 완료 처리 =>
                          await wordViewModel.markWordAsDone(wordViewModel
                              .wordList[wordViewModel.currentIndex.value]
                              .wordCard);

                          // 마지막 단어가 아닐 경우 뒤로가기, 마지막 단어일 경우 홈으로 이동
                          wordViewModel.currentIndex.value <
                                  wordViewModel.wordList.length - 1
                              ? Get.back()
                              : Get.offAllNamed('/');

                          // 다음 단어로 넘어가기
                          if (wordViewModel.currentIndex.value <
                              wordViewModel.wordList.length - 1) {
                            pageController.animateToPage(
                              wordViewModel.currentIndex.value + 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );

                            // currentIndex 증가
                            wordViewModel.currentIndex.value =
                                wordViewModel.currentIndex.value + 1;
                          }
                        },
                        // 마지막 단어일 경우 홈으로 이동
                        child: Text(wordViewModel.currentIndex.value <
                                wordViewModel.wordList.length - 1
                            ? '다음 단어'
                            : '홈으로 이동'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text(
                "학습 완료",
                style: TextStyle(
                  color: ColorSystem.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
