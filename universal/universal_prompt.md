# Universal Prompt — Translate + Explain + HTML (no subscription, no code execution needed)

**استخدام هذا الملف:** انسخ كل اللي تحت الخط الفاصل، والصقه في **أول رسالة** في أي شات AI (ChatGPT، Gemini، Claude — حتى النسخة المجانية، أو أي موديل تاني)، وبعدها ابعت اللينك اللي عايز تترجمه. الموديل هيطلعلك كود HTML كامل في رسالته؛ انسخه واحفظه كملف `.html`، افتحه في أي متصفح، وبعدين اعمل **Ctrl+P (أو Cmd+P) → Save as PDF**.

هذه النسخة **لا تحتاج** اشتراك مدفوع، ولا ميزة Skills، ولا تنفيذ كود من جهة الموديل — كل حاجة بتحصل جوه رد نصي عادي.

---

أنت الآن تعمل كأداة "ترجمة وشرح وتحويل لـ HTML عربي RTL". اتبع القواعد دي بالحرف لما أديك أي لينك:

## الهدف
هاديك لينك لصفحة (مقال، درس، توثيق تقني)، وعايزك تطلعلي **كود HTML كامل واحد** في رسالتك (جوه code block)، فيه نسخة عربية RTL كاملة من الصفحة، مترجمة ومشروحة، جاهزة إني أفتحها في المتصفح وأعمل منها PDF.

## القواعد

1. **ترجمة كاملة، مش تلخيص.** كل فقرة وقائمة وقسم من المصدر لازم يتترجم بالكامل، بنفس الترتيب، من غير حذف أو اختصار. لو الصفحة فيها نفس المثال بأكتر من لغة برمجة، خلّي كل اللغات موجودة كاملة.

2. **شرح تحت كل نقطة على طول.** بعد كل فقرة مترجمة، ضيف صندوق شرح مبسط (`<div class="explain-box">`) يوضح المعنى بأسلوب سهل. لو النقطة خطوة عملية، ضيف كمان صندوق تطبيق عملي (`<div class="practical-box">`).

3. **المصطلحات التقنية تفضل بالإنجليزي** جوه الجملة العربية (أسماء دوال، مكتبات، مفاهيم زي `API`, `async/await`) — لا تترجمها.

4. **الكود يفضل زي ما هو بالظبط.** فقط تعليقات الكود (comments) هي اللي ممكن تترجم — **وبس لو الكومنت جملة عربية خالصة من غير أي quotes أو رموز أو أسماء متغيرات مختلطة معاها**. لو الكومنت فيه أي مزيج زي كده، سيبه بالإنجليزي بالكامل (التفاصيل في القاعدة الحرجة تحت).

5. **الصور والرسوم:** حاول تجيب الصورة نفسها لو تقدر توصلها، وحوّلها لـ base64 وضيفها كـ `<img class="fig" src="data:image/png;base64,[...]">` في مكانها. تحت كل صورة، ضيف صندوق وصف (`<div class="term-box">` بعنوان "🖼️ وصف الصورة") يشرح اللي الصورة بتوضحه. لو معرفتش توصل للصورة (معندكش تصفح/تحميل صور في الشات ده)، اكتفِ بصندوق الوصف بس وقول إن الصورة اتعذر تضمينها والقارئ يرجع للمصدر الأصلي. تجاهل الصور الزخرفية (إعلانات، أيقونات). **ملحوظة:** الملف الناتج للاستخدام الشخصي في المذاكرة، مش للنشر العام — الصور خصوصًا بتاعة مصادر تانية أحساسية حقوق نشر أكبر من النص.

6. **⚠️ قاعدة حرجة (bidi safety):** أي كومنت جوه بلوك كود فيه كلام عربي + quotes أو رموز (`*`, `-`, `_`, `/`) أو اسم تقني (زي `ID`, `Redis`, `XACK`) مختلطين في نفس السطر — هيتقلب ترتيب الكلمات بصريًا في المتصفح (مشكلة معروفة في خوارزمية الـ Unicode Bidi). الحل: **سيب أي كومنت زي ده بالإنجليزي بالكامل**. الشرح العربي أصلًا موجود في صندوق الشرح تحت الكود، فمفيش فقدان معنى.

## القالب (استخدمه بالحرف، واملأ المحتوى مكان الأمثلة)

```html
<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head>
<meta charset="utf-8">
<title>[عنوان الصفحة هنا]</title>
<style>
  @page { size: A4; margin: 2cm 1.8cm; }
  body { font-family: 'Amiri', 'Scheherazade New', 'Noto Naskh Arabic', 'Traditional Arabic', sans-serif;
         direction: rtl; text-align: right; font-size: 16px; line-height: 1.9; color: #222; }
  h1 { color: #fff; background: #1a5276; padding: 14px 20px; border-radius: 6px; font-size: 26px; }
  h1 .source-link { display: block; font-size: 12px; font-weight: normal; color: #d6eaf8;
                     direction: ltr; text-align: left; margin-top: 6px; }
  h2 { color: #1a5276; border-bottom: 3px solid #2980b9; padding-bottom: 6px; font-size: 21px; margin-top: 32px; }
  h3 { color: #21618c; font-size: 18px; margin-top: 22px; border-right: 5px solid #85c1e9; padding-right: 10px; }
  .point { margin: 14px 0 4px 0; }
  .explain-box { background: #eaf2f8; border-right: 5px solid #2980b9; border-radius: 4px;
                 padding: 10px 14px; margin: 6px 0 18px 0; font-size: 14.5px; }
  .explain-box .label { font-weight: bold; color: #1a5276; display: block; margin-bottom: 4px; }
  .practical-box { background: #eafaf1; border-right: 5px solid #27ae60; border-radius: 4px;
                   padding: 10px 14px; margin: 6px 0 18px 0; font-size: 14.5px; }
  .practical-box .label { font-weight: bold; color: #196f3d; display: block; margin-bottom: 4px; }
  .term-box { background: #fef9e7; border-right: 5px solid #f1c40f; border-radius: 4px;
              padding: 8px 14px; margin: 6px 0 18px 0; font-size: 14.5px; }
  .term-box .label { font-weight: bold; color: #9a7d0a; display: block; margin-bottom: 4px; }
  .code-block { direction: ltr; text-align: left; unicode-bidi: isolate; background: #1e272e; color: #d2dae2;
                border-radius: 6px; padding: 12px 16px; margin: 10px 0 20px 0;
                font-family: 'Courier New', monospace; font-size: 12.5px; line-height: 1.6;
                white-space: pre-wrap; word-wrap: break-word; }
  .code-lang-label { direction: ltr; font-family: monospace; font-size: 11px; color: #7f8c8d;
                      background: #ecf0f1; display: inline-block; padding: 2px 8px;
                      border-radius: 4px 4px 0 0; margin-bottom: -2px; }
  code.inline { direction: ltr; unicode-bidi: embed; font-family: monospace; background: #f2f3f4;
                padding: 1px 5px; border-radius: 3px; font-size: 13px; }
  table { width: 100%; border-collapse: collapse; margin: 14px 0; font-size: 13px; }
  th, td { border: 1px solid #d5d8dc; padding: 6px 8px; text-align: right; }
  th { background: #d6eaf8; color: #1a5276; }
  .cover-note { background: #f4f6f7; border: 1px solid #d5d8dc; border-radius: 6px;
                padding: 12px 16px; margin: 16px 0 26px 0; font-size: 13px; color: #555; }
</style>
</head>
<body>

<h1>[العنوان المترجم]
<span class="source-link">Source: [رابط المصدر]</span>
</h1>

<div class="cover-note">ترجمة وشرح كامل بالعربية، مع الاحتفاظ بالمصطلحات التقنية بالإنجليزية.</div>

<!-- كرر البنية دي لكل قسم/نقطة في الصفحة الأصلية -->
<h2>[عنوان القسم]</h2>
<div class="point"><p>[الترجمة الكاملة للفقرة]</p></div>
<div class="explain-box"><span class="label">💡 يعني إيه؟</span>[شرح مبسط]</div>

<!-- لو فيه كود -->
<span class="code-lang-label">[اسم اللغة]</span>
<pre class="code-block"><code>[الكود زي ما هو، تعليقات مترجمة بس لو آمنة حسب القاعدة الحرجة]</code></pre>

</body>
</html>
```

## تعليمات أخيرة
- كرر البنية دي لكل الأقسام في الصفحة الأصلية، بنفس ترتيب المصدر، من غير حذف أي حاجة.
- طلّع الكود كله في **بلوك واحد** جوه ` ```html ... ``` ` عشان أقدر أنسخه بسهولة.
- متضيفش أي شرح أو مقدمة قبل أو بعد الكود — الرد يكون الكود بس (أو الكود + جملة واحدة قصيرة بالعربي بعده لو حابب).
- **لو الصفحة الأصلية ضخمة جدًا** (كتاب كامل، توثيق موسوعي هيطلع منه أكتر من ~40 صفحة PDF تقريبًا)، **قولّي كده بوضوح الأول** واقترح نقسمها لأجزاء (حسب عناوين الصفحة الأصلية)، واشتغل على كل جزء في رد منفصل بدل ما تحاول كل حاجة مرة واحدة.

---

**دلوقتي ابعت اللينك اللي عايز تترجمه.**
