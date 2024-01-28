import 'package:flutter/material.dart';

//Add this CustomPaint widget to the Widget Tree
// CustomPaint(
//     size: Size(1280, 720),
//     painter: RPSCustomPainter(),
// )

//Copy this CustomPainter code to the Bottom of the File


class RPSCustomPainter extends CustomPainter {
  double y = 1000;
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(532, 3854);
    path_0.lineTo(530, 3173);
    path_0.lineTo(553, 3154);
    path_0.cubicTo(575, 3135, 575, 3135, 558, 3156);
    path_0.cubicTo(541, 3175, 540, 3227, 537, 3856);
    path_0.lineTo(535, 4535);
    path_0.lineTo(532, 3854);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Colors.amber.withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(12365, 4010);
    path_1.cubicTo(12365, 3721, 12366, 3603, 12367, 3748);
    path_1.cubicTo(12369, 3892, 12369, 4128, 12367, 4273);
    path_1.cubicTo(12366, 4417, 12365, 4299, 12365, 4010);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(1361, 3191);
    path_2.cubicTo(1353, 3186, 1366, 3184, 1396, 3187);
    path_2.cubicTo(1423, 3190, 1447, 3194, 1449, 3196);
    path_2.cubicTo(1458, 3204, 1374, 3199, 1361, 3191);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(2281, 3191);
    path_3.cubicTo(2271, 3185, 2282, 3183, 2311, 3187);
    path_3.cubicTo(2335, 3190, 2357, 3194, 2359, 3196);
    path_3.cubicTo(2369, 3205, 2294, 3199, 2281, 3191);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(3203, 3190);
    path_4.cubicTo(3169, 3176, 3175, 3169, 3210, 3182);
    path_4.cubicTo(3227, 3187, 3254, 3190, 3270, 3188);
    path_4.cubicTo(3286, 3186, 3297, 3187, 3294, 3192);
    path_4.cubicTo(3287, 3203, 3231, 3201, 3203, 3190);
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(4160, 3190);
    path_5.cubicTo(4174, 3186, 4192, 3182, 4200, 3181);
    path_5.cubicTo(4213, 3180, 4213, 3181, 4200, 3190);
    path_5.cubicTo(4192, 3195, 4174, 3199, 4160, 3199);
    path_5.lineTo(4135, 3198);
    path_5.lineTo(4160, 3190);
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(5058, 3193);
    path_6.cubicTo(5070, 3191, 5088, 3191, 5098, 3193);
    path_6.cubicTo(5107, 3196, 5097, 3198, 5075, 3197);
    path_6.cubicTo(5053, 3197, 5045, 3195, 5058, 3193);
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(5968, 3193);
    path_7.cubicTo(5980, 3191, 6000, 3191, 6013, 3193);
    path_7.cubicTo(6025, 3195, 6015, 3197, 5990, 3197);
    path_7.cubicTo(5965, 3197, 5955, 3195, 5968, 3193);
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(6893, 3193);
    path_8.cubicTo(6902, 3191, 6916, 3191, 6923, 3193);
    path_8.cubicTo(6929, 3196, 6922, 3198, 6905, 3198);
    path_8.cubicTo(6889, 3198, 6883, 3196, 6893, 3193);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(7776, 3191);
    path_9.cubicTo(7765, 3187, 7780, 3184, 7813, 3184);
    path_9.cubicTo(7843, 3185, 7863, 3188, 7857, 3192);
    path_9.cubicTo(7842, 3202, 7801, 3201, 7776, 3191);
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(10560, 3190);
    path_10.cubicTo(10574, 3186, 10594, 3182, 10605, 3182);
    path_10.cubicTo(10621, 3182, 10620, 3184, 10600, 3190);
    path_10.cubicTo(10586, 3194, 10566, 3198, 10555, 3198);
    path_10.cubicTo(10539, 3198, 10540, 3196, 10560, 3190);
    path_10.close();

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(11450, 3190);
    path_11.cubicTo(11432, 3184, 11438, 3183, 11477, 3184);
    path_11.cubicTo(11505, 3184, 11523, 3188, 11517, 3192);
    path_11.cubicTo(11503, 3201, 11483, 3201, 11450, 3190);
    path_11.close();

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(5915, 3180);
    path_12.cubicTo(5912, 3174, 5916, 3173, 5924, 3176);
    path_12.cubicTo(5942, 3183, 5945, 3190, 5931, 3190);
    path_12.cubicTo(5925, 3190, 5918, 3186, 5915, 3180);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(9603, 3183);
    path_13.cubicTo(9612, 3181, 9626, 3181, 9633, 3183);
    path_13.cubicTo(9639, 3186, 9632, 3188, 9615, 3188);
    path_13.cubicTo(9599, 3188, 9593, 3186, 9603, 3183);
    path_13.close();

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);

    Path path_14 = Path();
    path_14.moveTo(9678, 3183);
    path_14.cubicTo(9685, 3180, 9694, 3181, 9697, 3184);
    path_14.cubicTo(9701, 3187, 9695, 3190, 9684, 3189);
    path_14.cubicTo(9673, 3189, 9670, 3186, 9678, 3183);
    path_14.close();

    Paint paint_14_fill = Paint()..style = PaintingStyle.fill;
    paint_14_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_14, paint_14_fill);

    Path path_15 = Path();
    path_15.moveTo(10508, 3183);
    path_15.cubicTo(10515, 3180, 10524, 3181, 10527, 3184);
    path_15.cubicTo(10531, 3187, 10525, 3190, 10514, 3189);
    path_15.cubicTo(10503, 3189, 10500, 3186, 10508, 3183);
    path_15.close();

    Paint paint_15_fill = Paint()..style = PaintingStyle.fill;
    paint_15_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_15, paint_15_fill);

    Path path_16 = Path();
    path_16.moveTo(2235, 3170);
    path_16.cubicTo(2232, 3164, 2236, 3163, 2244, 3166);
    path_16.cubicTo(2262, 3173, 2265, 3180, 2251, 3180);
    path_16.cubicTo(2245, 3180, 2238, 3176, 2235, 3170);
    path_16.close();

    Paint paint_16_fill = Paint()..style = PaintingStyle.fill;
    paint_16_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_16, paint_16_fill);

    Path path_17 = Path();
    path_17.moveTo(4080, 3170);
    path_17.cubicTo(4071, 3164, 4070, 3160, 4077, 3160);
    path_17.cubicTo(4083, 3160, 4092, 3165, 4095, 3170);
    path_17.cubicTo(4103, 3182, 4099, 3182, 4080, 3170);
    path_17.close();

    Paint paint_17_fill = Paint()..style = PaintingStyle.fill;
    paint_17_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_17, paint_17_fill);

    Path path_18 = Path();
    path_18.moveTo(6804, 3164);
    path_18.cubicTo(6786, 3150, 6786, 3150, 6810, 3161);
    path_18.cubicTo(6841, 3175, 6846, 3180, 6834, 3180);
    path_18.cubicTo(6828, 3180, 6815, 3173, 6804, 3164);
    path_18.close();

    Paint paint_18_fill = Paint()..style = PaintingStyle.fill;
    paint_18_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_18, paint_18_fill);

    Path path_19 = Path();
    path_19.moveTo(6985, 3165);
    path_19.cubicTo(7015, 3140, 7044, 3126, 7036, 3139);
    path_19.cubicTo(7032, 3145, 7014, 3157, 6997, 3166);
    path_19.cubicTo(6967, 3180, 6966, 3180, 6985, 3165);
    path_19.close();

    Paint paint_19_fill = Paint()..style = PaintingStyle.fill;
    paint_19_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_19, paint_19_fill);

    Path path_20 = Path();
    path_20.moveTo(7881, 3176);
    path_20.cubicTo(7883, 3174, 7896, 3167, 7910, 3161);
    path_20.cubicTo(7934, 3150, 7934, 3150, 7916, 3164);
    path_20.cubicTo(7900, 3177, 7867, 3188, 7881, y);
    path_20.close();

    Paint paint_20_fill = Paint()..style = PaintingStyle.fill;
    paint_20_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_20, paint_20_fill);

    Path path_21 = Path();
    path_21.moveTo(8807, 3169);
    path_21.cubicTo(8814, 3162, 8822, 3159, 8825, 3162);
    path_21.cubicTo(8828, 3165, 8823, 3171, 8813, 3174);
    path_21.cubicTo(8799, 3180, 8798, 3179, 8807, 3169);
    path_21.close();

    Paint paint_21_fill = Paint()..style = PaintingStyle.fill;
    paint_21_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_21, paint_21_fill);

    Path path_22 = Path();
    path_22.moveTo(9560, 3170);
    path_22.cubicTo(9551, 3164, 9550, 3160, 9557, 3160);
    path_22.cubicTo(9563, 3160, 9572, 3165, 9575, 3170);
    path_22.cubicTo(9583, 3182, 9579, 3182, 9560, 3170);
    path_22.close();

    Paint paint_22_fill = Paint()..style = PaintingStyle.fill;
    paint_22_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_22, paint_22_fill);

    Path path_23 = Path();
    path_23.moveTo(9710, 3176);
    path_23.cubicTo(9710, 3174, 9717, 3169, 9726, 3166);
    path_23.cubicTo(9734, 3163, 9738, 3164, 9735, 3170);
    path_23.cubicTo(9729, 3180, 9710, 3184, 9710, 3176);
    path_23.close();

    Paint paint_23_fill = Paint()..style = PaintingStyle.fill;
    paint_23_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_23, paint_23_fill);

    Path path_24 = Path();
    path_24.moveTo(10470, 3170);
    path_24.cubicTo(10461, 3164, 10460, 3160, 10467, 3160);
    path_24.cubicTo(10473, 3160, 10482, 3165, 10485, 3170);
    path_24.cubicTo(10493, 3182, 10489, 3182, 10470, 3170);
    path_24.close();

    Paint paint_24_fill = Paint()..style = PaintingStyle.fill;
    paint_24_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_24, paint_24_fill);

    Path path_25 = Path();
    path_25.moveTo(11390, 3170);
    path_25.cubicTo(11381, 3164, 11380, 3160, 11387, 3160);
    path_25.cubicTo(11393, 3160, 11402, 3165, 11405, 3170);
    path_25.cubicTo(11413, 3182, 11409, 3182, 11390, 3170);
    path_25.close();

    Paint paint_25_fill = Paint()..style = PaintingStyle.fill;
    paint_25_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_25, paint_25_fill);

    Path path_26 = Path();
    path_26.moveTo(11557, 3169);
    path_26.cubicTo(11564, 3162, 11572, 3159, 11575, 3162);
    path_26.cubicTo(11578, 3165, 11573, 3171, 11563, 3174);
    path_26.cubicTo(11549, 3180, 11548, 3179, 11557, 3169);
    path_26.close();

    Paint paint_26_fill = Paint()..style = PaintingStyle.fill;
    paint_26_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_26, paint_26_fill);

    Path path_27 = Path();
    path_27.moveTo(12355, 3169);
    path_27.cubicTo(12351, 3163, 12338, 3155, 12326, 3150);
    path_27.lineTo(12305, 3141);
    path_27.lineTo(12327, 3141);
    path_27.cubicTo(12340, 3140, 12354, 3149, 12360, 3160);
    path_27.cubicTo(12381, 3166, 12388, 3155, 12369, y);
    path_27.close();

    Paint paint_27_fill = Paint()..style = PaintingStyle.fill;
    paint_27_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_27, paint_27_fill);

    Path path_28 = Path();
    path_28.moveTo(3139, 3149);
    path_28.lineTo(3115, 3129);
    path_28.lineTo(3143, 3146);
    path_28.cubicTo(3158, 3155, 3170, 3164, 3170, 3166);
    path_28.cubicTo(3170, 3174, 3162, 3170, 3139, 3149);
    path_28.close();

    Paint paint_28_fill = Paint()..style = PaintingStyle.fill;
    paint_28_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_28, paint_28_fill);

    Path path_29 = Path();
    path_29.moveTo(5835, 3124);
    path_29.lineTo(5795, 3088);
    path_29.lineTo(5838, 3120);
    path_29.cubicTo(5874, 3147, 5887, 3160, 5878, 3160);
    path_29.cubicTo(5876, 3160, 5857, 3144, 5835, 3124);
    path_29.close();

    Paint paint_29_fill = Paint()..style = PaintingStyle.fill;
    paint_29_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_29, paint_29_fill);

    Path path_30 = Path();
    path_30.moveTo(9514, 3138);
    path_30.lineTo(9495, 3115);
    path_30.lineTo(9518, 3134);
    path_30.cubicTo(9539, 3152, 9545, 3160, 9537, 3160);
    path_30.cubicTo(9535, 3160, 9525, 3150, 9514, 3138);
    path_30.close();

    Paint paint_30_fill = Paint()..style = PaintingStyle.fill;
    paint_30_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_30, paint_30_fill);

    Path path_31 = Path();
    path_31.moveTo(6735, 3113);
    path_31.cubicTo(6713, 3094, 6704, 3082, 6715, 3088);
    path_31.cubicTo(6734, 3097, 6789, 3151, 6779, 3150);
    path_31.cubicTo(6777, 3149, 6757, 3133, 6735, 3113);
    path_31.close();

    Paint paint_31_fill = Paint()..style = PaintingStyle.fill;
    paint_31_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_31, paint_31_fill);

    Path path_32 = Path();
    path_32.moveTo(4009, 3113);
    path_32.lineTo(3985, 3085);
    path_32.lineTo(4013, 3109);
    path_32.cubicTo(4038, 3132, 4045, 3140, 4037, 3140);
    path_32.cubicTo(4035, 3140, 4023, 3128, 4009, 3113);
    path_32.close();

    Paint paint_32_fill = Paint()..style = PaintingStyle.fill;
    paint_32_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_32, paint_32_fill);

    Path path_33 = Path();
    path_33.moveTo(7644, 3108);
    path_33.lineTo(7615, 3075);
    path_33.lineTo(7648, 3104);
    path_33.cubicTo(7665, 3121, 7680, 3135, 7680, 3137);
    path_33.cubicTo(7680, 3145, 7672, 3138, 7644, 3108);
    path_33.close();

    Paint paint_33_fill = Paint()..style = PaintingStyle.fill;
    paint_33_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_33, paint_33_fill);

    Path path_34 = Path();
    path_34.moveTo(8559, 3103);
    path_34.lineTo(8525, 3065);
    path_34.lineTo(8563, 3099);
    path_34.cubicTo(8597, 3132, 8605, 3140, 8597, 3140);
    path_34.cubicTo(8595, 3140, 8578, 3123, 8559, 3103);
    path_34.close();

    Paint paint_34_fill = Paint()..style = PaintingStyle.fill;
    paint_34_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_34, paint_34_fill);

    Path path_35 = Path();
    path_35.moveTo(2470, 3127);
    path_35.cubicTo(2470, 3125, 2485, 3111, 2503, 3094);
    path_35.lineTo(2535, 3065);
    path_35.lineTo(2506, 3098);
    path_35.cubicTo(2478, 3128, 2470, 3135, 2470, y);
    path_35.close();

    Paint paint_35_fill = Paint()..style = PaintingStyle.fill;
    paint_35_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_35, paint_35_fill);

    Path path_36 = Path();
    path_36.moveTo(3084, 3108);
    path_36.lineTo(3065, 3085);
    path_36.lineTo(3088, 3104);
    path_36.cubicTo(3100, 3115, 3110, 3125, 3110, 3127);
    path_36.cubicTo(3110, 3135, 3102, 3129, 3084, 3108);
    path_36.close();

    Paint paint_36_fill = Paint()..style = PaintingStyle.fill;
    paint_36_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_36, paint_36_fill);

    Path path_37 = Path();
    path_37.moveTo(4320, 3105);
    path_37.cubicTo(4333, 3091, 4346, 3080, 4348, 3080);
    path_37.cubicTo(4351, 3080, 4343, 3091, 4330, 3105);
    path_37.cubicTo(4317, 3119, 4304, 3130, 4302, 3130);
    path_37.cubicTo(4299, 3130, 4307, 3119, 4320, 3105);
    path_37.close();

    Paint paint_37_fill = Paint()..style = PaintingStyle.fill;
    paint_37_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_37, paint_37_fill);

    Path path_38 = Path();
    path_38.moveTo(6669, 3053);
    path_38.cubicTo(6656, 3037, 6657, 3036, 6673, 3049);
    path_38.cubicTo(6682, 3056, 6690, 3064, 6690, 3066);
    path_38.cubicTo(6690, 3074, 6682, 3069, 6669, 3053);
    path_38.close();

    Paint paint_38_fill = Paint()..style = PaintingStyle.fill;
    paint_38_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_38, paint_38_fill);

    Path path_39 = Path();
    path_39.moveTo(3470, 3046);
    path_39.cubicTo(3470, 3044, 3478, 3036, 3488, 3029);
    path_39.cubicTo(3503, 3016, 3504, 3017, 3491, 3033);
    path_39.cubicTo(3478, 3049, 3470, 3054, 3470, y);
    path_39.close();

    Paint paint_39_fill = Paint()..style = PaintingStyle.fill;
    paint_39_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_39, paint_39_fill);

    Path path_40 = Path();
    path_40.moveTo(4380, 3046);
    path_40.cubicTo(4380, 3044, 4388, 3036, 4398, 3029);
    path_40.cubicTo(4413, 3016, 4414, 3017, 4401, 3033);
    path_40.cubicTo(4388, 3049, 4380, 3054, 4380, y);
    path_40.close();

    Paint paint_40_fill = Paint()..style = PaintingStyle.fill;
    paint_40_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_40, paint_40_fill);

    Path path_41 = Path();
    path_41.moveTo(5739, 3033);
    path_41.cubicTo(5726, 3017, 5727, 3016, 5743, 3029);
    path_41.cubicTo(5759, 3042, 5764, 3050, 5756, 3050);
    path_41.cubicTo(5754, 3050, 5746, 3042, 5739, 3033);
    path_41.close();

    Paint paint_41_fill = Paint()..style = PaintingStyle.fill;
    paint_41_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_41, paint_41_fill);

    Path path_42 = Path();
    path_42.moveTo(6230, 3037);
    path_42.cubicTo(6230, 3035, 6245, 3021, 6263, 3004);
    path_42.lineTo(6295, 2975);
    path_42.lineTo(6266, 3008);
    path_42.cubicTo(6238, 3038, 6230, 3045, 6230, y);
    path_42.close();

    Paint paint_42_fill = Paint()..style = PaintingStyle.fill;
    paint_42_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_42, paint_42_fill);

    Path path_43 = Path();
    path_43.moveTo(6609, 2993);
    path_43.lineTo(6575, 2955);
    path_43.lineTo(6615, 2990);
    path_43.cubicTo(6637, 3009, 6657, 3026, 6659, 3028);
    path_43.cubicTo(6661, 3029, 6659, 3030, 6654, 3030);
    path_43.cubicTo(6648, 3030, 6628, 3013, 6609, 2993);
    path_43.close();

    Paint paint_43_fill = Paint()..style = PaintingStyle.fill;
    paint_43_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_43, paint_43_fill);

    Path path_44 = Path();
    path_44.moveTo(1670, 3017);
    path_44.cubicTo(1670, 3015, 1685, 3001, 1703, 2984);
    path_44.lineTo(1735, 2955);
    path_44.lineTo(1706, 2988);
    path_44.cubicTo(1678, 3018, 1670, 3025, 1670, y);
    path_44.close();

    Paint paint_44_fill = Paint()..style = PaintingStyle.fill;
    paint_44_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_44, paint_44_fill);

    Path path_45 = Path();
    path_45.moveTo(4794, 2998);
    path_45.lineTo(4775, 2975);
    path_45.lineTo(4798, 2994);
    path_45.cubicTo(4819, 3012, 4825, 3020, 4817, 3020);
    path_45.cubicTo(4815, 3020, 4805, 3010, 4794, 2998);
    path_45.close();

    Paint paint_45_fill = Paint()..style = PaintingStyle.fill;
    paint_45_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_45, paint_45_fill);

    Path path_46 = Path();
    path_46.moveTo(8444, 2998);
    path_46.lineTo(8425, 2975);
    path_46.lineTo(8448, 2994);
    path_46.cubicTo(8460, 3005, 8470, 3015, 8470, 3017);
    path_46.cubicTo(8470, 3025, 8462, 3019, 8444, 2998);
    path_46.close();

    Paint paint_46_fill = Paint()..style = PaintingStyle.fill;
    paint_46_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_46, paint_46_fill);

    Path path_47 = Path();
    path_47.moveTo(3510, 3006);
    path_47.cubicTo(3510, 3004, 3518, 2996, 3528, 2989);
    path_47.cubicTo(3543, 2976, 3544, 2977, 3531, 2993);
    path_47.cubicTo(3518, 3009, 3510, 3014, 3510, y);
    path_47.close();

    Paint paint_47_fill = Paint()..style = PaintingStyle.fill;
    paint_47_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_47, paint_47_fill);

    Path path_48 = Path();
    path_48.moveTo(3869, 2993);
    path_48.cubicTo(3856, 2977, 3857, 2976, 3873, 2989);
    path_48.cubicTo(3889, 3002, 3894, 3010, 3886, 3010);
    path_48.cubicTo(3884, 3010, 3876, 3002, 3869, 2993);
    path_48.close();

    Paint paint_48_fill = Paint()..style = PaintingStyle.fill;
    paint_48_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_48, paint_48_fill);

    Path path_49 = Path();
    path_49.moveTo(5340, 3006);
    path_49.cubicTo(5340, 3004, 5348, 2996, 5358, 2989);
    path_49.cubicTo(5373, 2976, 5374, 2977, 5361, 2993);
    path_49.cubicTo(5348, 3009, 5340, 3014, 5340, y);
    path_49.close();

    Paint paint_49_fill = Paint()..style = PaintingStyle.fill;
    paint_49_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_49, paint_49_fill);

    Path path_50 = Path();
    path_50.moveTo(9359, 2993);
    path_50.cubicTo(9346, 2977, 9347, 2976, 9363, 2989);
    path_50.cubicTo(9372, 2996, 9380, 3004, 9380, 3006);
    path_50.cubicTo(9380, 3014, 9372, 3009, 9359, 2993);
    path_50.close();

    Paint paint_50_fill = Paint()..style = PaintingStyle.fill;
    paint_50_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_50, paint_50_fill);

    Path path_51 = Path();
    path_51.moveTo(9319, 2963);
    path_51.cubicTo(9306, 2947, 9307, 2946, 9323, 2959);
    path_51.cubicTo(9332, 2966, 9340, 2974, 9340, 2976);
    path_51.cubicTo(9340, 2984, 9332, 2979, 9319, 2963);
    path_51.close();

    Paint paint_51_fill = Paint()..style = PaintingStyle.fill;
    paint_51_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_51, paint_51_fill);

    Path path_52 = Path();
    path_52.moveTo(3550, 2966);
    path_52.cubicTo(3550, 2964, 3557, 2959, 3566, 2956);
    path_52.cubicTo(3574, 2953, 3578, 2954, 3575, 2960);
    path_52.cubicTo(3569, 2970, 3550, 2974, 3550, 2966);
    path_52.close();

    Paint paint_52_fill = Paint()..style = PaintingStyle.fill;
    paint_52_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_52, paint_52_fill);

    Path path_53 = Path();
    path_53.moveTo(1908, 2923);
    path_53.cubicTo(1915, 2920, 1924, 2921, 1927, 2924);
    path_53.cubicTo(1931, 2927, 1925, 2930, 1914, 2929);
    path_53.cubicTo(1903, 2929, 1900, 2926, 1908, 2923);
    path_53.close();

    Paint paint_53_fill = Paint()..style = PaintingStyle.fill;
    paint_53_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_53, paint_53_fill);

    Path path_54 = Path();
    path_54.moveTo(2718, 2923);
    path_54.cubicTo(2725, 2920, 2734, 2921, 2737, 2924);
    path_54.cubicTo(2741, 2927, 2735, 2930, 2724, 2929);
    path_54.cubicTo(2713, 2929, 2710, 2926, 2718, 2923);
    path_54.close();

    Paint paint_54_fill = Paint()..style = PaintingStyle.fill;
    paint_54_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_54, paint_54_fill);

    Path path_55 = Path();
    path_55.moveTo(4558, 2923);
    path_55.cubicTo(4565, 2920, 4574, 2921, 4577, 2924);
    path_55.cubicTo(4581, 2927, 4575, 2930, 4564, 2929);
    path_55.cubicTo(4553, 2929, 4550, 2926, 4558, 2923);
    path_55.close();

    Paint paint_55_fill = Paint()..style = PaintingStyle.fill;
    paint_55_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_55, paint_55_fill);

    Path path_56 = Path();
    path_56.moveTo(6380, 2920);
    path_56.cubicTo(6388, 2915, 6404, 2910, 6414, 2910);
    path_56.cubicTo(6440, 2910, 6432, 2916, 6395, 2924);
    path_56.cubicTo(6373, 2929, 6369, 2928, 6380, 2920);
    path_56.close();

    Paint paint_56_fill = Paint()..style = PaintingStyle.fill;
    paint_56_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_56, paint_56_fill);

    Path path_57 = Path();
    path_57.moveTo(943, 2913);
    path_57.cubicTo(952, 2911, 968, 2911, 978, 2913);
    path_57.cubicTo(987, 2916, 979, 2918, 960, 2918);
    path_57.cubicTo(941, 2918, 933, 2916, 943, 2913);
    path_57.close();

    Paint paint_57_fill = Paint()..style = PaintingStyle.fill;
    paint_57_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_57, paint_57_fill);

    Path path_58 = Path();
    path_58.moveTo(6463, 2913);
    path_58.cubicTo(6472, 2911, 6486, 2911, 6493, 2913);
    path_58.cubicTo(6499, 2916, 6492, 2918, 6475, 2918);
    path_58.cubicTo(6459, 2918, 6453, 2916, 6463, 2913);
    path_58.close();

    Paint paint_58_fill = Paint()..style = PaintingStyle.fill;
    paint_58_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_58, paint_58_fill);

    Path path_59 = Path();
    path_59.moveTo(7348, 2913);
    path_59.cubicTo(7360, 2911, 7380, 2911, 7393, 2913);
    path_59.cubicTo(7405, 2915, 7395, 2917, 7370, 2917);
    path_59.cubicTo(7345, 2917, 7335, 2915, 7348, 2913);
    path_59.close();

    Paint paint_59_fill = Paint()..style = PaintingStyle.fill;
    paint_59_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_59, paint_59_fill);

    Path path_60 = Path();
    path_60.moveTo(8263, 2913);
    path_60.cubicTo(8278, 2911, 8300, 2911, 8313, 2913);
    path_60.cubicTo(8325, 2915, 8313, 2917, 8285, 2917);
    path_60.cubicTo(8258, 2917, 8247, 2915, 8263, 2913);
    path_60.close();

    Paint paint_60_fill = Paint()..style = PaintingStyle.fill;
    paint_60_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_60, paint_60_fill);

    Path path_61 = Path();
    path_61.moveTo(9163, 2913);
    path_61.cubicTo(9178, 2911, 9202, 2911, 9218, 2913);
    path_61.cubicTo(9233, 2915, 9220, 2917, 9190, 2917);
    path_61.cubicTo(9160, 2917, 9147, 2915, 9163, 2913);
    path_61.close();

    Paint paint_61_fill = Paint()..style = PaintingStyle.fill;
    paint_61_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_61, paint_61_fill);

    Path path_62 = Path();
    path_62.moveTo(10078, 2913);
    path_62.cubicTo(10085, 2910, 10094, 2911, 10097, 2914);
    path_62.cubicTo(10101, 2917, 10095, 2920, 10084, 2919);
    path_62.cubicTo(10073, 2919, 10070, 2916, 10078, 2913);
    path_62.close();

    Paint paint_62_fill = Paint()..style = PaintingStyle.fill;
    paint_62_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_62, paint_62_fill);

    Path path_63 = Path();
    path_63.moveTo(10123, 2913);
    path_63.cubicTo(10132, 2911, 10146, 2911, 10153, 2913);
    path_63.cubicTo(10159, 2916, 10152, 2918, 10135, 2918);
    path_63.cubicTo(10119, 2918, 10113, 2916, 10123, 2913);
    path_63.close();

    Paint paint_63_fill = Paint()..style = PaintingStyle.fill;
    paint_63_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_63, paint_63_fill);

    Path path_64 = Path();
    path_64.moveTo(10988, 2913);
    path_64.cubicTo(10994, 2911, 11006, 2911, 11013, 2913);
    path_64.cubicTo(11019, 2916, 11014, 2918, 11000, 2918);
    path_64.cubicTo(10986, 2918, 10981, 2916, 10988, 2913);
    path_64.close();

    Paint paint_64_fill = Paint()..style = PaintingStyle.fill;
    paint_64_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_64, paint_64_fill);

    Path path_65 = Path();
    path_65.moveTo(11918, 2913);
    path_65.cubicTo(11930, 2911, 11950, 2911, 11963, 2913);
    path_65.cubicTo(11975, 2915, 11965, 2917, 11940, 2917);
    path_65.cubicTo(11915, 2917, 11905, 2915, 11918, 2913);
    path_65.close();

    Paint paint_65_fill = Paint()..style = PaintingStyle.fill;
    paint_65_fill.color = Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_65, paint_65_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
