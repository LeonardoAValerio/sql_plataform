import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sql_plataform/core/database/objectbox.g.dart';
import 'package:sql_plataform/core/database/objectbox_manager.dart';
import 'package:sql_plataform/core/utils/path.dart';
import 'package:sql_plataform/models/chapter.dart';
import 'package:sql_plataform/views/widgets/common/app_markdown.dart';
import 'package:sql_plataform/services/nlp/embedding_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class FaqScreen extends StatefulWidget {
  final int chapterId;

  FaqScreen(this.chapterId);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late Chapter chapter;
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  final EmbeddingService _embeddingService = EmbeddingService();

  @override
  void initState() {
    super.initState();
    _loadData();
    _embeddingService.init();
  }

  void _loadData() {
    final loadedChapter = ObjectBoxManager.chapterBox
        .query(Chapter_.refId.equals(widget.chapterId))
        .build()
        .findFirst();

    if (loadedChapter == null) {
      throw ArgumentError("Not found ChapterId");
    }

    setState(() {
      chapter = loadedChapter;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<Float32List> _generateEmbedding(String text) async {
    return await _embeddingService.generateEmbedding(text);
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _controller.clear();
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final userEmbedding = await _generateEmbedding(text);
      
      // ObjectBox HNSW search
      final query = ObjectBoxManager.faqBox
          .query(Faq_.embedding.nearestNeighborsF32(userEmbedding, 1)
          .and(Faq_.chapter.equals(chapter.id)))
          .build();
      
      final resultsWithScores = query.findWithScores();
      query.close();

      String response;
      if (resultsWithScores.isNotEmpty) {
        final nearest = resultsWithScores.first;
        final score = nearest.score;
        
        if (score <= 0.8) {
          response = nearest.object.answer;
        } else {
          response = "Não encontrei nenhuma pergunta sobre esse assunto nesse capítulo.";
        }
      } else {
        response = "Não encontrei nenhuma pergunta sobre esse assunto nesse capítulo.";
      }

      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: "Erro ao processar sua pergunta: ${e.toString()}", isUser: false));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(pathImg("background.png")),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _buildChatBubble(message);
                  },
                ),
              ),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(height: 16),
        Image(image: AssetImage(pathImg("hacker.png")), width: 120),
        SizedBox(height: 16),
        Text(
          "Está com alguma dúvida?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Fique a vontade para perguntar sobre:",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "SELECT, WHERE, FROM", // This could be made dynamic later
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    if (message.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(bottom: 16, left: 64),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFF333333), // Dark grey from image
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            message.text,
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: 16, right: 32),
          child: AppMarkdown(
            data: message.text,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(color: Colors.white70, fontSize: 16)
            ),
          ),
        ),
      );
    }
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF222222), // Even darker grey
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: _controller,
          onSubmitted: _handleSubmitted,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Digite sua pergunta....",
            hintStyle: TextStyle(color: Colors.white38),
            contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.send, color: Colors.white54),
              onPressed: () => _handleSubmitted(_controller.text),
            ),
          ),
        ),
      ),
    );
  }
}