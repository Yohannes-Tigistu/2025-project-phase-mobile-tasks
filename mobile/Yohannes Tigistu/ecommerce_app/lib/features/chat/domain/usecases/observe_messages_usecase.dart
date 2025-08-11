import '../entities/message.dart';
import '../repository/chat_repository.dart';

class ObserveMessagesUsecase {
  final ChatRepository chatRepository;

  ObserveMessagesUsecase(this.chatRepository);

  Stream<Message> call() => chatRepository.observeMessages();
}
