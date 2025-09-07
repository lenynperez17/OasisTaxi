// ignore_for_file: deprecated_member_use, unused_field, unused_element, avoid_print, unreachable_switch_default, avoid_web_libraries_in_flutter, library_private_types_in_public_api
import 'package:flutter/material.dart';
import '../../core/theme/modern_theme.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  
  // Support data
  List<SupportTicket> _tickets = [];
  List<FAQ> _faqs = [];
  bool _isLoading = true;
  
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'general';
  String _selectedPriority = 'medium';
  
  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    
    _slideAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    );
    
    _loadSupportData();
  }
  
  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  void _loadSupportData() async {
    // Simulate loading support data
    await Future.delayed(Duration(seconds: 1));
    
    setState(() {
      _tickets = [
        SupportTicket(
          id: 'TK001',
          subject: 'Problema con el pago',
          description: 'No se procesó el pago de mi último viaje',
          category: SupportCategory.payment,
          priority: TicketPriority.high,
          status: TicketStatus.inProgress,
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
          updatedAt: DateTime.now().subtract(Duration(minutes: 30)),
          responses: [
            TicketResponse(
              id: 'R001',
              message: 'Hemos recibido tu reporte y estamos investigando el problema.',
              isFromSupport: true,
              createdAt: DateTime.now().subtract(Duration(minutes: 45)),
            ),
            TicketResponse(
              id: 'R002',
              message: 'El problema ha sido identificado y ya se procesó tu reembolso.',
              isFromSupport: true,
              createdAt: DateTime.now().subtract(Duration(minutes: 30)),
            ),
          ],
        ),
        SupportTicket(
          id: 'TK002',
          subject: 'Conductor no llegó al punto de recogida',
          description: 'El conductor canceló el viaje sin avisar',
          category: SupportCategory.trip,
          priority: TicketPriority.medium,
          status: TicketStatus.resolved,
          createdAt: DateTime.now().subtract(Duration(days: 1)),
          updatedAt: DateTime.now().subtract(Duration(hours: 6)),
          responses: [
            TicketResponse(
              id: 'R003',
              message: 'Lamentamos esta experiencia. Hemos aplicado una penalización al conductor.',
              isFromSupport: true,
              createdAt: DateTime.now().subtract(Duration(hours: 8)),
            ),
          ],
        ),
      ];
      
      _faqs = [
        FAQ(
          id: '1',
          question: '¿Cómo puedo cambiar mi método de pago?',
          answer: 'Puedes cambiar tu método de pago desde el menú "Métodos de Pago" en tu perfil. Toca el método que deseas usar como predeterminado.',
          category: 'Pagos',
          isHelpful: null,
        ),
        FAQ(
          id: '2',
          question: '¿Qué hago si el conductor no llega?',
          answer: 'Si el conductor no llega en 10 minutos, puedes cancelar el viaje sin costo. Si ya pasó mucho tiempo, contacta a soporte.',
          category: 'Viajes',
          isHelpful: null,
        ),
        FAQ(
          id: '3',
          question: '¿Cómo puedo reportar un problema?',
          answer: 'Puedes reportar problemas desde esta pantalla de soporte, o directamente desde los detalles de tu viaje.',
          category: 'General',
          isHelpful: null,
        ),
        FAQ(
          id: '4',
          question: '¿Puedo programar un viaje con anticipación?',
          answer: 'Sí, puedes programar viajes hasta con 7 días de anticipación desde la pantalla principal.',
          category: 'Viajes',
          isHelpful: null,
        ),
        FAQ(
          id: '5',
          question: '¿Cómo funciona el sistema de calificaciones?',
          answer: 'Después de cada viaje puedes calificar tu experiencia del 1 al 5. Esto nos ayuda a mantener la calidad del servicio.',
          category: 'General',
          isHelpful: null,
        ),
      ];
      
      _isLoading = false;
    });
    
    _fadeController.forward();
    _slideController.forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: ModernTheme.backgroundLight,
        appBar: AppBar(
          backgroundColor: ModernTheme.oasisGreen,
          elevation: 0,
          title: Text(
            'Centro de Soporte',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.help_outline), text: 'FAQs'),
              Tab(icon: Icon(Icons.support_agent), text: 'Mis Tickets'),
              Tab(icon: Icon(Icons.add_circle_outline), text: 'Nuevo Ticket'),
              Tab(icon: Icon(Icons.contact_support), text: 'Contacto'),
            ],
          ),
        ),
        body: _isLoading ? _buildLoadingState() : _buildTabViews(),
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ModernTheme.oasisGreen),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando información de soporte...',
            style: TextStyle(
              color: ModernTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabViews() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: TabBarView(
            children: [
              _buildFAQsTab(),
              _buildTicketsTab(),
              _buildNewTicketTab(),
              _buildContactTab(),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildFAQsTab() {
    final categories = _faqs.map((faq) => faq.category).toSet().toList();
    
    return SingleChildScrollView(
      child: Column(
        children: [
          // Search bar
          Container(
            margin: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar en preguntas frecuentes...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ModernTheme.oasisGreen),
                ),
              ),
            ),
          ),
          
          // Categories
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildCategoryChip('Todas', true);
                }
                return _buildCategoryChip(categories[index - 1], false);
              },
            ),
          ),
          
          // FAQs list
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            itemCount: _faqs.length,
            itemBuilder: (context, index) {
              final faq = _faqs[index];
              return _buildFAQCard(faq);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoryChip(String category, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          // Implement category filtering
        },
        backgroundColor: Colors.white,
        selectedColor: ModernTheme.oasisGreen.withValues(alpha: 0.2),
        checkmarkColor: ModernTheme.oasisGreen,
        labelStyle: TextStyle(
          color: isSelected ? ModernTheme.oasisGreen : ModernTheme.textSecondary,
        ),
      ),
    );
  }
  
  Widget _buildFAQCard(FAQ faq) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: ModernTheme.textPrimary,
          ),
        ),
        subtitle: Container(
          margin: EdgeInsets.only(top: 4),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: ModernTheme.oasisGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            faq.category,
            style: TextStyle(
              fontSize: 10,
              color: ModernTheme.oasisGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.answer,
                  style: TextStyle(
                    color: ModernTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      '¿Te fue útil esta respuesta?',
                      style: TextStyle(
                        fontSize: 12,
                        color: ModernTheme.textSecondary,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.thumb_up_outlined),
                      color: faq.isHelpful == true ? ModernTheme.success : ModernTheme.textSecondary,
                      onPressed: () => _markFAQHelpful(faq, true),
                    ),
                    IconButton(
                      icon: Icon(Icons.thumb_down_outlined),
                      color: faq.isHelpful == false ? ModernTheme.error : ModernTheme.textSecondary,
                      onPressed: () => _markFAQHelpful(faq, false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTicketsTab() {
    if (_tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.support_agent,
              size: 64,
              color: ModernTheme.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'No tienes tickets de soporte',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ModernTheme.textSecondary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Crea un nuevo ticket si necesitas ayuda',
              style: TextStyle(
                color: ModernTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _tickets.length,
      itemBuilder: (context, index) {
        final ticket = _tickets[index];
        return _buildTicketCard(ticket);
      },
    );
  }
  
  Widget _buildTicketCard(SupportTicket ticket) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _viewTicketDetails(ticket),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(ticket.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusText(ticket.status),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(ticket.status),
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    ticket.id,
                    style: TextStyle(
                      fontSize: 12,
                      color: ModernTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                ticket.subject,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ModernTheme.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                ticket.description,
                style: TextStyle(
                  color: ModernTheme.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    _getCategoryIcon(ticket.category),
                    size: 16,
                    color: ModernTheme.textSecondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    _getCategoryText(ticket.category),
                    style: TextStyle(
                      fontSize: 12,
                      color: ModernTheme.textSecondary,
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: ModernTheme.textSecondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    _formatDateTime(ticket.updatedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: ModernTheme.textSecondary,
                    ),
                  ),
                  Spacer(),
                  if (ticket.responses.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: ModernTheme.oasisGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${ticket.responses.length} respuesta${ticket.responses.length > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 10,
                          color: ModernTheme.oasisGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildNewTicketTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crear Nuevo Ticket de Soporte',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ModernTheme.textPrimary,
              ),
            ),
            SizedBox(height: 24),
            
            // Category selection
            Text(
              'Categoría',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: ModernTheme.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ModernTheme.oasisGreen),
                ),
              ),
              items: [
                DropdownMenuItem(value: 'general', child: Text('General')),
                DropdownMenuItem(value: 'trip', child: Text('Problemas con viaje')),
                DropdownMenuItem(value: 'payment', child: Text('Problemas de pago')),
                DropdownMenuItem(value: 'account', child: Text('Cuenta y perfil')),
                DropdownMenuItem(value: 'technical', child: Text('Problemas técnicos')),
                DropdownMenuItem(value: 'other', child: Text('Otro')),
              ],
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),
            SizedBox(height: 16),
            
            // Priority selection
            Text(
              'Prioridad',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: ModernTheme.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedPriority,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ModernTheme.oasisGreen),
                ),
              ),
              items: [
                DropdownMenuItem(value: 'low', child: Text('Baja')),
                DropdownMenuItem(value: 'medium', child: Text('Media')),
                DropdownMenuItem(value: 'high', child: Text('Alta')),
                DropdownMenuItem(value: 'urgent', child: Text('Urgente')),
              ],
              onChanged: (value) {
                setState(() => _selectedPriority = value!);
              },
            ),
            SizedBox(height: 16),
            
            // Subject
            Text(
              'Asunto',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: ModernTheme.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                hintText: 'Describe brevemente el problema',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ModernTheme.oasisGreen),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingresa un asunto';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            
            // Description
            Text(
              'Descripción',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: ModernTheme.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Proporciona detalles sobre el problema...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ModernTheme.oasisGreen),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor describe el problema';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitTicket,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ModernTheme.oasisGreen,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Enviar Ticket',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Contact options
          _buildContactOption(
            'Llamar a Soporte',
            'Habla directamente con nuestro equipo',
            Icons.phone,
            ModernTheme.primaryBlue,
            '+51 1 234-5678',
            _callSupport,
          ),
          _buildContactOption(
            'Chat en Vivo',
            'Chatea con un agente en tiempo real',
            Icons.chat,
            ModernTheme.oasisGreen,
            'Disponible 24/7',
            _openLiveChat,
          ),
          _buildContactOption(
            'Email',
            'Envía un correo a nuestro equipo',
            Icons.email,
            Colors.orange,
            'soporte@oasistaxi.com',
            _sendEmail,
          ),
          _buildContactOption(
            'WhatsApp',
            'Contacta por WhatsApp',
            Icons.message,
            Colors.green,
            '+51 987 654 321',
            _openWhatsApp,
          ),
          
          SizedBox(height: 24),
          
          // Office hours
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ModernTheme.backgroundLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Horarios de Atención',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ModernTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 12),
                _buildHourRow('Lunes - Viernes', '8:00 AM - 10:00 PM'),
                _buildHourRow('Sábados', '9:00 AM - 8:00 PM'),
                _buildHourRow('Domingos', '10:00 AM - 6:00 PM'),
                SizedBox(height: 8),
                Text(
                  '* Chat en vivo disponible 24/7',
                  style: TextStyle(
                    fontSize: 12,
                    color: ModernTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24),
          
          // Social media
          Text(
            'Síguenos en redes sociales',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ModernTheme.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton('Facebook', Icons.facebook, Colors.blue),
              _buildSocialButton('Twitter', Icons.alternate_email, Colors.lightBlue),
              _buildSocialButton('Instagram', Icons.camera_alt, Colors.purple),
              _buildSocialButton('LinkedIn', Icons.work, Colors.indigo),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildContactOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String info,
    VoidCallback onTap,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ModernTheme.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: ModernTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      info,
                      style: TextStyle(
                        fontSize: 14,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: ModernTheme.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHourRow(String day, String hours) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: ModernTheme.textPrimary,
            ),
          ),
          Text(
            hours,
            style: TextStyle(
              color: ModernTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSocialButton(String platform, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _openSocialMedia(platform),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
  
  Color _getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return ModernTheme.warning;
      case TicketStatus.inProgress:
        return ModernTheme.primaryBlue;
      case TicketStatus.resolved:
        return ModernTheme.success;
      case TicketStatus.closed:
        return ModernTheme.textSecondary;
    }
  }
  
  String _getStatusText(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'Abierto';
      case TicketStatus.inProgress:
        return 'En Progreso';
      case TicketStatus.resolved:
        return 'Resuelto';
      case TicketStatus.closed:
        return 'Cerrado';
    }
  }
  
  IconData _getCategoryIcon(SupportCategory category) {
    switch (category) {
      case SupportCategory.general:
        return Icons.help_outline;
      case SupportCategory.trip:
        return Icons.directions_car;
      case SupportCategory.payment:
        return Icons.payment;
      case SupportCategory.account:
        return Icons.person;
      case SupportCategory.technical:
        return Icons.build;
      case SupportCategory.other:
        return Icons.more_horiz;
    }
  }
  
  String _getCategoryText(SupportCategory category) {
    switch (category) {
      case SupportCategory.general:
        return 'General';
      case SupportCategory.trip:
        return 'Viaje';
      case SupportCategory.payment:
        return 'Pago';
      case SupportCategory.account:
        return 'Cuenta';
      case SupportCategory.technical:
        return 'Técnico';
      case SupportCategory.other:
        return 'Otro';
    }
  }
  
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
  
  void _markFAQHelpful(FAQ faq, bool helpful) {
    setState(() {
      final index = _faqs.indexWhere((f) => f.id == faq.id);
      if (index != -1) {
        _faqs[index] = FAQ(
          id: faq.id,
          question: faq.question,
          answer: faq.answer,
          category: faq.category,
          isHelpful: helpful,
        );
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gracias por tu feedback'),
        backgroundColor: ModernTheme.success,
      ),
    );
  }
  
  void _viewTicketDetails(SupportTicket ticket) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TicketDetailsScreen(ticket: ticket),
      ),
    );
  }
  
  void _submitTicket() {
    if (_formKey.currentState!.validate()) {
      // Simulate ticket creation
      final newTicket = SupportTicket(
        id: 'TK${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        subject: _subjectController.text,
        description: _descriptionController.text,
        category: _parseCategoryFromString(_selectedCategory),
        priority: _parsePriorityFromString(_selectedPriority),
        status: TicketStatus.open,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        responses: [],
      );
      
      setState(() {
        _tickets.insert(0, newTicket);
        _subjectController.clear();
        _descriptionController.clear();
        _selectedCategory = 'general';
        _selectedPriority = 'medium';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ticket creado exitosamente - ${newTicket.id}'),
          backgroundColor: ModernTheme.success,
        ),
      );
      
      // Switch to tickets tab
      DefaultTabController.of(context).animateTo(1);
    }
  }
  
  SupportCategory _parseCategoryFromString(String category) {
    switch (category) {
      case 'trip':
        return SupportCategory.trip;
      case 'payment':
        return SupportCategory.payment;
      case 'account':
        return SupportCategory.account;
      case 'technical':
        return SupportCategory.technical;
      case 'other':
        return SupportCategory.other;
      default:
        return SupportCategory.general;
    }
  }
  
  TicketPriority _parsePriorityFromString(String priority) {
    switch (priority) {
      case 'low':
        return TicketPriority.low;
      case 'high':
        return TicketPriority.high;
      case 'urgent':
        return TicketPriority.urgent;
      default:
        return TicketPriority.medium;
    }
  }
  
  void _callSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Llamando a soporte: +51 1 234-5678'),
        backgroundColor: ModernTheme.info,
      ),
    );
  }
  
  void _openLiveChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abriendo chat en vivo...'),
        backgroundColor: ModernTheme.info,
      ),
    );
  }
  
  void _sendEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abriendo cliente de correo...'),
        backgroundColor: ModernTheme.info,
      ),
    );
  }
  
  void _openWhatsApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abriendo WhatsApp...'),
        backgroundColor: ModernTheme.info,
      ),
    );
  }
  
  void _openSocialMedia(String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Abriendo $platform...'),
        backgroundColor: ModernTheme.info,
      ),
    );
  }
}

// Ticket Details Screen
class TicketDetailsScreen extends StatelessWidget {
  final SupportTicket ticket;
  
  const TicketDetailsScreen({super.key, required this.ticket});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ModernTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: ModernTheme.oasisGreen,
        title: Text(
          'Ticket ${ticket.id}',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ticket header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: ModernTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(ticket.status).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getStatusText(ticket.status),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(ticket.status),
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Creado: ${_formatDate(ticket.createdAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: ModernTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    ticket.subject,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ModernTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    ticket.description,
                    style: TextStyle(
                      color: ModernTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 16),
            
            // Responses
            if (ticket.responses.isNotEmpty) ...[
              Text(
                'Conversación',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ModernTheme.textPrimary,
                ),
              ),
              SizedBox(height: 12),
              ...ticket.responses.map((response) => _buildResponseCard(response)),
            ],
            
            SizedBox(height: 16),
            
            // Add response button
            if (ticket.status != TicketStatus.closed)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _addResponse(context),
                  icon: Icon(Icons.reply),
                  label: Text('Responder'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ModernTheme.oasisGreen,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildResponseCard(TicketResponse response) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: response.isFromSupport 
                  ? ModernTheme.oasisGreen.withValues(alpha: 0.1)
                  : ModernTheme.primaryBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              response.isFromSupport ? Icons.support_agent : Icons.person,
              color: response.isFromSupport 
                  ? ModernTheme.oasisGreen
                  : ModernTheme.primaryBlue,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: response.isFromSupport 
                    ? ModernTheme.oasisGreen.withValues(alpha: 0.05)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: response.isFromSupport 
                      ? ModernTheme.oasisGreen.withValues(alpha: 0.2)
                      : Colors.grey.shade300,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        response.isFromSupport ? 'Soporte Oasis' : 'Tú',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: response.isFromSupport 
                              ? ModernTheme.oasisGreen
                              : ModernTheme.primaryBlue,
                        ),
                      ),
                      Spacer(),
                      Text(
                        _formatDateTime(response.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: ModernTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    response.message,
                    style: TextStyle(
                      color: ModernTheme.textPrimary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getStatusColor(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return ModernTheme.warning;
      case TicketStatus.inProgress:
        return ModernTheme.primaryBlue;
      case TicketStatus.resolved:
        return ModernTheme.success;
      case TicketStatus.closed:
        return ModernTheme.textSecondary;
    }
  }
  
  String _getStatusText(TicketStatus status) {
    switch (status) {
      case TicketStatus.open:
        return 'Abierto';
      case TicketStatus.inProgress:
        return 'En Progreso';
      case TicketStatus.resolved:
        return 'Resuelto';
      case TicketStatus.closed:
        return 'Cerrado';
    }
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
  
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
  
  void _addResponse(BuildContext context) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Agregar Respuesta'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Escribe tu respuesta...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Respuesta enviada'),
                    backgroundColor: ModernTheme.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ModernTheme.oasisGreen,
            ),
            child: Text('Enviar'),
          ),
        ],
      ),
    );
  }
}

// Models
class SupportTicket {
  final String id;
  final String subject;
  final String description;
  final SupportCategory category;
  final TicketPriority priority;
  final TicketStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TicketResponse> responses;
  
  SupportTicket({
    required this.id,
    required this.subject,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.responses,
  });
}

class TicketResponse {
  final String id;
  final String message;
  final bool isFromSupport;
  final DateTime createdAt;
  
  TicketResponse({
    required this.id,
    required this.message,
    required this.isFromSupport,
    required this.createdAt,
  });
}

class FAQ {
  final String id;
  final String question;
  final String answer;
  final String category;
  final bool? isHelpful;
  
  FAQ({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.isHelpful,
  });
}

enum SupportCategory {
  general,
  trip,
  payment,
  account,
  technical,
  other,
}

enum TicketPriority {
  low,
  medium,
  high,
  urgent,
}

enum TicketStatus {
  open,
  inProgress,
  resolved,
  closed,
}