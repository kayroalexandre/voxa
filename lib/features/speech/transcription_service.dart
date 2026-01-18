class TranscriptionService {
  /// Transcribes the audio from the given path.
  ///
  /// A full implementation for transcribing audio files is pending.
  Future<String> transcribe(String audioPath) async {
    // A real implementation would use a service or package capable of
    // processing an audio file. As this is not yet implemented, we throw
    // an exception to make it clear that this functionality is not available,
    // avoiding silent failures or mock data in the application flow.
    throw UnimplementedError(
        'A transcrição de arquivos de áudio ainda não foi implementada.');
  }
}
