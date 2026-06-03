# استخدام نسخة Alpine لأنها خفيفة جداً وسريعة
FROM alpine:latest

# تحديث النظام وتثبيت أداة ttyd بالإضافة إلى سطر أوامر bash
RUN apk update && apk add --no-cache bash ttyd

# تحديد متغيرات البيئة الافتراضية
# يمكنك تغيير اسم المستخدم هنا، وتم وضع كلمة المرور التي طلبتها
ENV USERNAME=admin
ENV PASSWORD=mosap@123123

# منصة Railway تقوم بتعيين متغير PORT تلقائياً، سنضع 8080 كاحتياط
ENV PORT=8080

# الأمر الذي سيتم تشغيله عند بدء الحاوية
# سيقوم بربط المنفذ، وتفعيل تسجيل الدخول، وفتح شاشة bash
CMD sh -c "ttyd -p ${PORT} -c ${USERNAME}:${PASSWORD} bash"
