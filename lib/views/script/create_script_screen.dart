import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class CreateScriptPage extends StatefulWidget {
  @override
  _CreateScriptPageState createState() => _CreateScriptPageState();
}

class _CreateScriptPageState extends State<CreateScriptPage> {
  bool isRecording = false;
  bool handDone = false;
  TextEditingController textEditingController = TextEditingController();
  stt.SpeechToText speechToText = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    requestPermission();
    speechToText.initialize(
      onError: (val) => print('Error: $val'),
      onStatus: (status) {
        print('Status changed: $status'); // 모든 상태 변화 로깅
        handleStatus(status); // 상태 처리를 위한 함수 호출
      },
    );
  }
  void handleStatus(String status) {
    print('Handling Status: $status'); // 현재 처리 중인 상태 로깅
    print('handDone: $handDone');
    if(handDone) {
      return;
    }
    if (status == 'done') {
      print("Status is 'done'. Stopping and restarting listening.");
      stopListening();
      // 잠시 후 다시 시작하기 위해 delay를 사용
      Future.delayed(Duration(milliseconds:100), () {
        startListening();
      });
      if (status == 'notListening') {
        print("Status is 'notListening'. Restarting listening.");
        startListening();
      }
    }
    // 필요한 경우 여기에 다른 상태에 대한 처리를 추가할 수 있습니다.
  }


  @override
  @override
  void dispose() {
    // SpeechToText 리스닝을 멈춥니다.
    speechToText.stop();

    // SpeechToText 리소스를 정리합니다.
    speechToText.cancel();
    // 텍스트 컨트롤러를 정리합니다.
    textEditingController.dispose();

    super.dispose();
  }


  Future<void> requestPermission() async {
    var microphoneStatus = await Permission.microphone.status;
    if (!microphoneStatus.isGranted) {
      await Permission.microphone.request();
    }
  }

  void toggleRecording() {
    if (isRecording) {
      //완전히 끝내겠다고 설정하는 부분.
      handDone = true;
      stopListening();
    } else {
      handDone = false;
      startListening();
    }
  }

  Future<void> startListening() async {
    bool available = await speechToText.initialize(onError: (error) => print(error), onStatus: (status) {
      print(status);
      handleStatus(status);
    });

    if (!available) {
      print("The user has denied the use of speech recognition or an error occurred during initialization.");
      return;
    }
    speechToText.listen(
      onResult: (result)
      {
        if (mounted) {
          setState(() {
            print('onResult: ${result.finalResult}');
            if (result.finalResult) {
              // 기존 텍스트에 이어서 새로 인식된 텍스트를 추가합니다.
              textEditingController.text += result.recognizedWords + " ";
            }
          }
          );
        }
      },
      listenFor: const Duration(minutes: 5),
      pauseFor: const Duration(seconds: 3),
    );
    if (mounted) { setState(() => isRecording = true);}
  }

  Future<void> stopListening() async {
    bool available = await speechToText.initialize(onError: (error) => print(error), onStatus: (status) {
      print(status);
      handleStatus(status);
    });
    speechToText.stop();
    print('멈출라고');
    if (mounted) {
      setState(() => isRecording = false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('대본으로 학습하기'),
          centerTitle: true,
          actions: <Widget>[
              TextButton(
                onPressed: () {
                  print("완료버튼 눌렀습니다.");
                },
                child: Text(
                  '완료',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                flex: 1,
                child: _TopPart()),
            Expanded(
              //2분의 1만 사용하도록 설정
              flex: 1,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 20, 25, 100),
                    child: TextField(
                      controller: textEditingController,
                      expands: true,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '음성 인식을 통해 발음이 여기에 표시됩니다...',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Ink(
                        decoration: BoxDecoration(
                          color: isRecording ? Colors.red : Colors.blue,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: toggleRecording,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Icon(
                              isRecording ? Icons.stop : Icons.mic,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('대본 생성하기'),
      centerTitle: true,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            print("완료버튼 눌렀습니다.");
          }, child: Text(
          '완료',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        ),
      ],
    );
  }
}

class _TopPart extends StatelessWidget {
  const _TopPart({super.key});

  @override
  Widget build(BuildContext context) {
    var textEditingController;
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 20, 25, 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: textEditingController,
          expands: true,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: '대본을 입력하세요...',
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
          ),
          textAlignVertical: TextAlignVertical.top,
        ),
      ),
    );
  }
}
