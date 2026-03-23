import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:onnxruntime/onnxruntime.dart';
import 'package:dart_bert_tokenizer/dart_bert_tokenizer.dart';

class EmbeddingService {
  late OrtSession _session;
  late WordPieceTokenizer _tokenizer;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    final vocabulary = await Vocabulary.fromFile('assets/models/vocab.txt');

    // 4. Instancia o Tokenizer com o parâmetro nomeado 'vocab'
    _tokenizer = WordPieceTokenizer(vocab: vocabulary)
      ..enableTruncation(maxLength: 128);

    // 5. Inicializa o ONNX
    OrtEnv.instance.init();
    final modelBytes = await rootBundle.load('assets/models/model.onnx');
    _session = OrtSession.fromBuffer(
      modelBytes.buffer.asUint8List(), 
      OrtSessionOptions()
    );

    _isInitialized = true;
  }

  Future<Float32List> generateEmbedding(String text) async {
  if (!_isInitialized) await init();

  final encoding = _tokenizer.encode(text);
  final inputIds = Int64List.fromList(encoding.ids);
  final attentionMask = Int64List.fromList(encoding.attentionMask);
  final typeIds = Int64List.fromList(encoding.typeIds);

  final shape = [1, inputIds.length];

  final inputs = {
    'input_ids': OrtValueTensor.createTensorWithDataList(inputIds, shape),
    'attention_mask': OrtValueTensor.createTensorWithDataList(attentionMask, shape),
    'token_type_ids': OrtValueTensor.createTensorWithDataList(typeIds, shape),
  };

  final outputs = _session.run(OrtRunOptions(), inputs);
  
  // O PROBLEMA ESTAVA AQUI:
  // O ONNX Runtime retorna List<List<List<double>>> para o Last Hidden State
  final rawData = outputs[0]?.value as List<dynamic>;
  
  // Extraímos a primeira (e única) sentença do batch
  // sequenceData terá o formato List<List<double>> (Sequence x 384)
  final List<dynamic> sequenceData = rawData[0]; 

  final embedding = _performMeanPooling(sequenceData, 384);

  // Cleanup
  inputs.forEach((key, value) => value.release());
  for (var element in outputs) {
    element?.release();
  }

  return embedding;
}

Float32List _performMeanPooling(List<dynamic> sequenceData, int dim) {
  final int seqLen = sequenceData.length;
  final Float32List meanVec = Float32List(dim);

  // Soma os vetores de cada token
  for (var tokenVector in sequenceData) {
    List<dynamic> vector = tokenVector as List<dynamic>;
    for (int j = 0; j < dim; j++) {
      meanVec[j] += vector[j];
    }
  }

  // Tira a média
  for (int j = 0; j < dim; j++) {
    meanVec[j] /= seqLen;
  }

  double norm = 0;
  for (var v in meanVec) norm += v * v;
  norm = sqrt(norm);
  for (int i = 0; i < dim; i++) meanVec[i] /= norm;

  return meanVec;
}

  void dispose() {
    _session.release();
    OrtEnv.instance.release();
  }
}