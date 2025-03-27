import 'package:asistencia_vial_app/src/pages/admin/estadisticas/estadisticas_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../utils/colors.dart';
import '../../../utils/fonts.dart';
import '../../../utils/textstyle.dart';





class EstadisticasPage extends StatelessWidget {
  EstadisticasController estadisticasController = Get.put(EstadisticasController());

  final List<String> denominaciones = [
    "Todas las denominaciones", "\$20", "\$10", "\$5", "\$2", "\$1",
    "50c", "25c", "10c", "5c", "1c"
  ];

  final List<String> lapsosTiempo = [
    "Turno", "Semanal", "Mensual", "Anual"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KConstantColors.bgColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
                SizedBox(height: 5),
              _buildFilters(context),
              SizedBox(height: 8),
              _buildSpendingChart(context),
            ],
          ),
        ),
      ),
    );
  }


  /// **Encabezado**
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Análisis',
        style: KCustomTextStyle.kBold(
          context,
          24,
          KConstantColors.whiteColor,
          KConstantFonts.manropeBold,
        ),
      ),
    );
  }

  /// **Filtros de fecha**
  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Obx(() => ElevatedButton.icon(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: estadisticasController.selectedDate.value,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                estadisticasController.updateDate(pickedDate);
              }
            },
            icon: Icon(Icons.calendar_today, color: Colors.white),
            label: Text(
              DateFormat('yyyy-MM-dd').format(estadisticasController.selectedDate.value),
              style: KCustomTextStyle.kMedium(
                context,
                14,
                Colors.white,
                KConstantFonts.manropeMedium,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF368983),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          )),
        ],
      ),
    );
  }

  /// **Gráfico de líneas con todas las horas del día**
  Widget _buildSpendingChart(BuildContext context) {
    return SizedBox(

      height: 350, // Aumenté la altura
      child: Padding(

        padding: const EdgeInsets.all(10),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 500, // Intervalo en el eje Y
              getDrawingHorizontalLine: (value) {
                return FlLine(color: Colors.grey[300], strokeWidth: 1, dashArray: [5, 5]);
              },
            ),
            titlesData: FlTitlesData(
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  interval: 500, // Define el intervalo del eje Y

                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}',
                      style: KCustomTextStyle.kMedium(
                        context,
                        12,
                        Color(0xFF368983),
                        KConstantFonts.manropeMedium,
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,

                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: estadisticasController.getSpots(),
                isCurved: true,
                color: Color(0xFF368983),
                barWidth: 3,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }




  Widget _buildPaymentTypes(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildPaymentTypeItem(
              context: context,
              icon: Icons.calendar_month,
              title: 'Day to day payments',
              amount: '\$22',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildPaymentTypeItem(
              context: context,
              icon: Icons.monetization_on_rounded,
              title: 'Scheduled payments',
              amount: '\$1',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTypeItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String amount,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF368983),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: KConstantColors.bgColor, size: 16),
        ),
        const SizedBox(height: 8),
        Text(
          amount,
          style: KCustomTextStyle.kBold(
            context,
            14, //fontsize

            Color(0xFF368983),
            KConstantFonts.manropeBold,
          ),
        ),
        Text(
          title,
          style: KCustomTextStyle.kMedium(context,14, //fontsize

              KConstantColors.faintWhiteColor, KConstantFonts.manropeMedium),
        ),
      ],
    );
  }


  Widget _buildScheduledPayments(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scheduled payments',
                style: KCustomTextStyle.kBold(
                  context,
                  14, //fontsize
                  KConstantColors.faintWhiteColor,
                  KConstantFonts.manropeBold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See all',
                  style: KCustomTextStyle.kMedium(
                    context,
                    14, //fontsize
                    KConstantColors.whiteColor,
                    KConstantFonts.manropeMedium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$12',
            style: KCustomTextStyle.kBold(
              context,
              14, //fontsize
              KConstantColors.whiteColor,
              KConstantFonts.manropeBold,
            ),
          ),
          Text(
            'Left to pay of \$1',
            style: KCustomTextStyle.kMedium(
              context,
              14, //fontsize
              KConstantColors.whiteColor,
              KConstantFonts.manropeMedium,
            ),
          ),
        ],
      ),
    );
  }
}