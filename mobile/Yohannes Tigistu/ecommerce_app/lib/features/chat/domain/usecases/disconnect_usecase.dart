import '../repository/chat_repository.dart';

class DisconnectUsecase {
  final ChatRepository chatRepository;

  DisconnectUsecase(this.chatRepository);

  Future<void> disconnect() async {
    return await chatRepository.disconnect();
  }
}
