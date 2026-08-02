# 📖 translate-explain-pdf

**A Claude Skill that turns any webpage into a fully translated, explained, RTL-formatted Arabic study PDF.**
**سكيل لـ Claude بيحوّل أي صفحة ويب لملف PDF عربي RTL كامل — مترجم ومشروح، جاهز للمذاكرة.**

<p align="center">
  <img alt="type" src="https://img.shields.io/badge/type-Claude%20Skill-5A67D8">
  <img alt="lang" src="https://img.shields.io/badge/output-Arabic%20RTL-2E86C1">
  <img alt="format" src="https://img.shields.io/badge/format-PDF-C0392B">
  <img alt="license" src="https://img.shields.io/badge/license-Proprietary%20%2F%20Personal%20Use-lightgrey">
</p>

---

## 🇬🇧 English

### Two ways to use this

| | **Claude Skill** (`translate-explain-pdf.skill`) | **Universal Prompt** (`universal/universal_prompt.md`) |
|---|---|---|
| Works with | Claude.ai / Claude Code / Cowork | **Any** AI chat — ChatGPT, Gemini, Claude Free, anything |
| Requires a paid plan? | Currently yes — custom Skills need Claude Pro or above | **No** — works on free tiers too |
| Needs code execution? | Yes (runs Python + WeasyPrint automatically) | **No** — plain text in, plain text out |
| Output | Ready-to-download PDF, generated automatically | HTML code you paste into a file yourself, then `Print → Save as PDF` from your browser |
| Best for | Hands-off automation if you already have Claude Pro | Anyone without a subscription, or who wants to use a different model |

Both produce the exact same visual design and follow the exact same bidi-safety rule — the Universal Prompt is just a manual-conversion version of the same instructions, for when Skills/code execution aren't available.

### What is this?

`translate-explain-pdf` is a [Claude Skill](https://www.anthropic.com) — a reusable instruction set that teaches Claude how to take **any link to a webpage, article, or technical documentation page** and turn it into a **complete, RTL-formatted Arabic study PDF**, without cutting corners.

Unlike a generic "summarize this page" prompt, this skill is built for **serious studying**:

- 📝 **Full translation, not a summary.** Every paragraph, list, and section from the source is translated — nothing is skipped or condensed.
- 💡 **Inline explanations, not a glossary at the end.** A simplified explanation box sits *directly under* every translated point — exactly where you need it, not buried in an appendix.
- 🌐 **Technical terms stay in English.** Function names, libraries, frameworks, and jargon (`API`, `async/await`, `XADD`...) are kept in English inline, because that's what you'll actually use at work with your team.
- 💻 **Code blocks are untouched.** The code itself is reproduced exactly as written in the source — only inline comments are translated. If the source page has the same example in multiple programming languages, **all of them are kept**, not just "the most popular one."
- 🎨 **Visually structured, not a wall of text.** Colored boxes distinguish explanations (blue), practical examples (green), and key term definitions (yellow), with proper RTL headings and styling.
- 🖼️ **Images and diagrams are embedded, not just described.** If the source page has a meaningful image/diagram, it's fetched, embedded directly in the PDF (as a base64 `<img>`, no external links to break later), and paired with an Arabic explanation box underneath. Falls back to a description-only box if the image can't be fetched. Note: the output is meant for personal study, not redistribution — images carry more copyright sensitivity than text.
- 🐛 **Bidi-safe by design.** Mixed Arabic/English text inside code comments is a classic source of visually broken, reordered text (a quirk of the Unicode Bidirectional Algorithm). This skill follows a strict, tested rule to avoid it — see [Why this skill exists](#-why-this-skill-exists) below.

### How it works

1. You give Claude a link and ask it to translate/explain/convert it to a study PDF.
2. Claude fetches the page content in full (falling back to `trafilatura` for content extraction if needed).
3. Claude translates every point, adds a simplified explanation directly beneath it, and flags practical/actionable steps with a separate example box.
4. Code blocks are preserved exactly as-is (comments translated, code untouched); multi-language examples are all kept in full.
5. Claude assembles a styled, RTL Arabic HTML document and renders it to PDF with [WeasyPrint](https://weasyprint.org/), using Arabic fonts (Amiri / Scheherazade) that render properly.
6. You get a downloadable, ready-to-study PDF.

### Requirements

- Python 3 with `weasyprint` and `trafilatura` (`pip install weasyprint trafilatura --break-system-packages`)
- Arabic-supporting fonts installed on the system (`fonts-hosny-amiri`, `fonts-sil-scheherazade`, `fonts-kacst` on Debian/Ubuntu)
- Claude with file-creation / code-execution capability (Claude.ai, Claude Code, or Cowork)

### Installation

1. Download `translate-explain-pdf.skill` from the [Releases](../../releases) page of this repo (the repo itself hosts the unpacked source: `SKILL.md`, `assets/`, `scripts/`, `references/`).
2. Upload the `.skill` file to Claude and click **"Save skill"** — this installs it to your profile so it's automatically available in future conversations.
3. If "Save skill" isn't available in your workspace, you can still just paste the contents of `SKILL.md` at the start of a conversation, or share a link directly and ask Claude to follow the same workflow.
4. First run in a fresh environment: Claude will run `scripts/setup.sh` once to install dependencies (Python packages + Arabic fonts) — it's idempotent, so it's safe if it runs more than once.

### 🆓 How to use this for free (no subscription, no Skills)

If you don't have Claude Pro, follow these exact steps — no code execution or subscription needed:

1. Open `universal/universal_prompt.md` from this repo and copy its **entire contents**.
2. Go to any AI chat you already have free access to (Claude.ai free tier, ChatGPT, Gemini, etc.).
3. Paste the copied text as your **first message**, then press send.
4. In your next message, paste the link to the page you want translated.
5. The model replies with a full HTML code block. Copy it.
6. Paste the code into a plain text editor (Notepad, TextEdit, VS Code — anything) and save the file with a `.html` extension, e.g. `my-notes.html`.
7. Open that `.html` file by double-clicking it — it opens in your default browser.
8. Press `Ctrl+P` (Windows/Linux) or `Cmd+P` (Mac), choose **"Save as PDF"** as the destination, and save.

That's it — no installs, no terminal, no subscription. Steps 6–8 are the only "manual" part, replacing what the Skill automates with code execution.

### 🚦 Known limitations & status

**This is an early release (v0.1).** See the [manual test log](evals/manual_test_log.md) for the full, honest list of what's been verified, what broke along the way (including the bidi bug and how it was fixed), and exactly how each test was run.

- ✅ Tested and confirmed working: heavy multi-language technical docs, plain narrative articles, RTL comparison tables, pages with images/diagrams (fetched and embedded directly in the PDF, with an Arabic description box underneath — falls back to description-only if the image can't be fetched), mixed-language sources (English text with embedded original Arabic terms), and the Universal Prompt path end-to-end.
- ⚠️ Image fetching depends on the runtime's network access to the source domain — confirmed working via `pdfimages` inspection in this test environment (using an allowlisted domain), but general websites may or may not be reachable depending on where you run this. See the test log for details.
- 📝 Documented but not stress-tested: 100+ page documents (a chunking policy exists in both `SKILL.md` and `universal_prompt.md`, but hasn't been run on a real 100+ page source).
- ❓ Not yet tested: source languages other than English (e.g. Chinese, Japanese documentation).
- The Claude Skill depends on `weasyprint` + Arabic fonts being installed in the execution environment — works out of the box in Claude.ai / Cowork / Claude Code (which can run `setup.sh`), but requires a paid plan since custom Skills currently aren't available on the free tier. The Universal Prompt path has none of these requirements.
- If you hit an edge case that breaks, please open an issue with the source URL — this log gets updated as more cases are tested.

### License

MIT — see [LICENSE](LICENSE). Note this covers the skill's own code/instructions, not the copyright of whatever third-party content you translate with it — always respect the original source's copyright.

### Usage

Just talk to Claude naturally:

> "Translate this page and turn it into a PDF: https://example.com/some-article"
> "Translate this article to Arabic and explain it, then give me a PDF: https://example.com/some-article"
> "I want to study from this link in Arabic — convert it to a study PDF"

### ⚠️ Why this skill exists (the bidi bug)

Early versions of this skill translated *every* code comment into Arabic, including ones that contained inline quotes, symbols, or short technical tokens (e.g. `# استخدام "0-*" عشان تسيب Redis يولّد الـ sequence`). This looked fine in the editor but rendered **visually scrambled** in the PDF — words appeared out of order, because the Unicode Bidirectional Algorithm doesn't reliably resolve runs where Arabic (RTL) and Latin/code (LTR) tokens with quotes/symbols are interleaved inside an already-LTR code block.

We tried several fixes (splitting lines, wrapping tokens in explicit Unicode isolate characters `U+2066`/`U+2069`) — none were 100% reliable across all cases. The rule that actually works:

> **If a code comment mixes Arabic text with quotes, symbols, or inline technical tokens, leave the whole comment in English.** The Arabic explanation lives in the explanation box right under the code block anyway, so nothing is lost — and the rendered PDF stays clean and readable.

This rule is baked into `SKILL.md` so every future run avoids the bug automatically.

### Repo structure

```
translate-explain-pdf/
├── SKILL.md                  # The skill instructions Claude follows
├── LICENSE                   # MIT license
├── README.md
├── assets/
│   └── template.html         # RTL HTML/CSS template (boxes, headings, code blocks)
├── scripts/
│   ├── setup.sh               # One-command environment setup (idempotent)
│   └── html_to_pdf.py        # WeasyPrint HTML → PDF converter
├── references/
│   └── design_notes.md       # CSS class reference + the bidi-safety rule in detail
└── evals/
    └── manual_test_log.md    # What's been tested, what broke, how it was fixed
```

### Limitations

- Very large pages (full books, huge documentation sites) should be split into multiple requests.
- Output quality depends on how cleanly the source page's content can be extracted (heavy JS-rendered sites may need manual copy-paste).
- This is a *personal study tool* — always respect the copyright of the original source; don't redistribute full translated copyrighted articles publicly.

---

## 🇸🇦 العربية

### طريقتين للاستخدام

| | **Claude Skill** (`translate-explain-pdf.skill`) | **البرومبت العام** (`universal/universal_prompt.md`) |
|---|---|---|
| بيشتغل مع | Claude.ai / Claude Code / Cowork | **أي** شات AI — ChatGPT، Gemini، Claude Free، أي حاجة |
| محتاج اشتراك مدفوع؟ | حاليًا آه — الـ Skills المخصصة محتاجة Claude Pro فما فوق | **لأ** — بيشتغل حتى على الخطط المجانية |
| محتاج تنفيذ كود؟ | آه (بيشغّل Python + WeasyPrint تلقائي) | **لأ** — نص عادي داخل، نص عادي خارج |
| الناتج | PDF جاهز للتحميل، بيتولّد تلقائي | كود HTML تلصقه إنت في ملف، وبعدين `Print → Save as PDF` من المتصفح |
| الأنسب لـ | أتمتة كاملة لو معاك Claude Pro أصلًا | أي حد من غير اشتراك، أو عايز يستخدم موديل تاني |

الاتنين بيطلعوا بنفس التصميم البصري بالظبط وبيتبعوا نفس قاعدة الأمان من الـ bidi — البرومبت العام هو بس نسخة تحويل يدوي من نفس التعليمات، لما الـ Skills أو تنفيذ الكود مش متاحين.

### إيه ده؟

`translate-explain-pdf` هو [Claude Skill](https://www.anthropic.com) — يعني مجموعة تعليمات قابلة لإعادة الاستخدام بتعلّم Claude إزاي ياخد **أي لينك لصفحة ويب، مقال، أو توثيق تقني** ويحوّله لملف **PDF عربي RTL كامل جاهز للمذاكرة**، من غير اختصار أو تلخيص.

على عكس أي prompt عادي بيقولك "لخصلي الصفحة دي"، الـ skill ده مبني للمذاكرة الجادة:

- 📝 **ترجمة كاملة، مش تلخيص.** كل فقرة وقائمة وقسم من المصدر بيتترجم — مفيش أي حاجة بتتحذف أو تتقصّر.
- 💡 **شرح تحت كل نقطة على طول، مش قاموس مصطلحات في الآخر.** صندوق شرح مبسط بيجي *مباشرة تحت* كل نقطة مترجمة — في المكان اللي محتاجه فيه، مش مدفون في ملحق آخر الملف.
- 🌐 **المصطلحات التقنية تفضل بالإنجليزي.** أسماء الدوال، المكتبات، الفريمووركس (`API`, `async/await`, `XADD`...) بتفضل إنجليزي جوه الجملة العربية، لأنك فعليًا هتستخدمها كده مع فريقك في الشغل.
- 💻 **الكود متلمسوش خالص.** الكود نفسه بيتنسخ زي ما هو بالظبط من المصدر — بس التعليقات (comments) جواه هي اللي بتتترجم. ولو الصفحة الأصلية فيها نفس المثال بأكتر من لغة برمجة، **كل اللغات بتفضل موجودة**، مش بس "الأشهر بينهم".
- 🎨 **منظّم بصريًا، مش نص سادة.** صناديق ملونة بتفرّق بين الشرح (أزرق)، الأمثلة العملية (أخضر)، وتعريفات المصطلحات المهمة (أصفر)، مع عناوين وتنسيق RTL صحيح.
- 🖼️ **الصور والرسوم بتتضمّن، مش بس توصف.** لو الصفحة الأصلية فيها صورة/رسم مهم، بيتجاب ويتضمّن مباشرة جوه الـ PDF (كـ `<img>` بصيغة base64، من غير أي روابط خارجية ممكن تتكسر بعدين)، مع صندوق شرح عربي تحته. لو الصورة اتعذر تحميلها، بيرجع لصندوق وصف بس. ملحوظة: الناتج للاستخدام الشخصي في المذاكرة مش للتوزيع — الصور فيها حساسية حقوق نشر أكبر من النص.
- 🐛 **آمن من مشاكل الـ bidi من الأساس.** خلط عربي/إنجليزي جوه تعليقات الكود من أشهر أسباب تكسير ترتيب النص بصريًا (مشكلة معروفة في خوارزمية الـ Unicode Bidirectional Algorithm). الـ skill ده بيتبع قاعدة صارمة ومُختبرة لتفادي المشكلة دي — التفاصيل في [ليه الـ skill ده موجود أصلًا](#-ليه-الـ-skill-ده-موجود-أصلًا) تحت.

### إزاي بيشتغل

1. تديله لينك وتطلب منه يترجمه/يشرحه/يحوّله لـ PDF مذاكرة.
2. Claude بيجيب محتوى الصفحة كامل (وبيستخدم `trafilatura` كبديل لو المحتوى مليان navigation/إعلانات).
3. بيترجم كل نقطة، ويضيف شرح مبسط تحتها على طول، ويحط صندوق مثال عملي منفصل للخطوات التطبيقية.
4. الكود بيتحفظ زي ما هو بالظبط (بس التعليقات بتتترجم)؛ لو فيه نفس المثال بأكتر من لغة، كل اللغات بتفضل موجودة كاملة.
5. Claude بيبني ملف HTML عربي RTL منسّق ويحوّله لـ PDF باستخدام [WeasyPrint](https://weasyprint.org/) مع خطوط عربية سليمة (Amiri / Scheherazade).
6. بتاخد ملف PDF جاهز للتحميل والمذاكرة.

### المتطلبات

- بايثون 3 مع `weasyprint` و`trafilatura` (`pip install weasyprint trafilatura --break-system-packages`)
- خطوط تدعم العربي متثبتة على النظام (`fonts-hosny-amiri`, `fonts-sil-scheherazade`, `fonts-kacst` على Debian/Ubuntu)
- Claude بميزة إنشاء ملفات/تنفيذ كود (Claude.ai، Claude Code، أو Cowork)

### التثبيت

1. حمّل ملف `translate-explain-pdf.skill` من صفحة [Releases](../../releases) بتاعة الريبو ده (الريبو نفسه بيحتوي على الملفات مفكوكة: `SKILL.md`, `assets/`, `scripts/`, `references/`).
2. ارفع ملف `.skill` لـ Claude ودوس **"Save skill"** — ده هيثبته في البروفايل بتاعك عشان يبقى متاح تلقائي في أي محادثة جاية.
3. لو "Save skill" مش متاح في الـ workspace بتاعك، برضه تقدر تلصق محتوى `SKILL.md` في بداية المحادثة، أو تدي Claude اللينك مباشرة وتطلب منه يتبع نفس الخطوات.
4. أول تشغيل في بيئة جديدة: Claude هيشغّل `scripts/setup.sh` مرة واحدة عشان يثبت المتطلبات (مكتبات بايثون + خطوط عربية) — السكريبت آمن التكرار (idempotent).

### 🆓 إزاي تستخدمها من غير اشتراك (من غير Skills)

لو معندكش Claude Pro، اتبع الخطوات دي بالظبط — من غير أي تنفيذ كود أو اشتراك:

1. افتح ملف `universal/universal_prompt.md` من الريبو ده وانسخ **كل محتواه**.
2. روح لأي شات AI متاح ليك مجانًا (Claude.ai النسخة المجانية، ChatGPT، Gemini، إلخ).
3. الصق النص اللي نسخته كـ **أول رسالة**، وابعتها.
4. في الرسالة اللي بعدها، الصق اللينك بتاع الصفحة اللي عايز تترجمها.
5. الموديل هيردّلك بكود HTML كامل. انسخه.
6. الصق الكود في أي محرر نصوص عادي (Notepad، TextEdit، VS Code — أي حاجة) واحفظ الملف بامتداد `.html`، مثلًا `ملاحظاتي.html`.
7. افتح الملف ده بدبل كليك — هيفتح في المتصفح الافتراضي بتاعك.
8. دوس `Ctrl+P` (ويندوز/لينكس) أو `Cmd+P` (ماك)، اختار **"Save as PDF"** كوجهة الحفظ، واحفظ.

كده خلاص — من غير تثبيت، من غير ترمينال، من غير اشتراك. الخطوات من 6 لـ 8 هي الجزء اليدوي الوحيد، وهي بديل الأتمتة اللي الـ Skill بتعملها بتنفيذ الكود.

### 🚦 حالة الـ skill والقيود

**دي نسخة مبكرة (v0.1).** شوف [سجل الاختبارات اليدوية](evals/manual_test_log.md) للقائمة الكاملة والصادقة لكل اللي اتجرب، واللي اتكسر في الطريق (بما فيه مشكلة الـ bidi وإزاي اتحلت)، وبالظبط إزاي كل اختبار اتعمل.

- ✅ اتجرب وأكّدنا إنه شغال: توثيق تقني ضخم متعدد اللغات، مقالات نثرية عادية، جداول مقارنة RTL، صفحات فيها صور/رسوم (بتتجاب وتتضمّن فعليًا جوه الـ PDF، مع صندوق وصف عربي تحتها — ولو الصورة اتعذر تحميلها بيرجع لخطة الوصف بس)، مصادر بلغة مختلطة (نص إنجليزي فيه مصطلحات عربية أصلية)، والبرومبت العام من الأول للآخر.
- ⚠️ تحميل الصور بيعتمد على إمكانية وصول بيئة التشغيل لدومين المصدر — اتأكد إنها شغالة فعليًا بفحص `pdfimages` في بيئة الاختبار دي (باستخدام دومين مسموح)، لكن المواقع العادية ممكن تكون متاحة أو محجوبة حسب البيئة اللي بتشغّل فيها الـ skill. التفاصيل في سجل الاختبارات.
- 📝 موثّق بس لسه معملوش stress-test: مستندات 100+ صفحة (فيه سياسة تقسيم مكتوبة في `SKILL.md` و`universal_prompt.md`، بس لسه معتجربتش على مصدر حقيقي 100+ صفحة).
- ❓ لسه معملوش تست: مصادر بلغة غير الإنجليزي (زي توثيق صيني أو ياباني).
- الـ Claude Skill بيعتمد على وجود `weasyprint` + خطوط عربية في بيئة التنفيذ — بيشتغل تلقائي في Claude.ai / Cowork / Claude Code (اللي بتقدر تشغّل `setup.sh`)، لكن محتاج اشتراك مدفوع لأن الـ Skills المخصصة حاليًا مش متاحة في النسخة المجانية. البرومبت العام مالوش أي متطلبات من دي خالص.
- لو واجهت حالة كسرت الـ skill، افتح issue وحط اللينك بتاع المصدر — السجل ده بيتحدث كل ما تتجرب حالات أكتر.

### الرخصة

MIT — التفاصيل في [LICENSE](LICENSE). الرخصة دي بتغطي كود وتعليمات الـ skill نفسه، مش حقوق نشر أي محتوى تترجمه بيه من مصادر تانية — احترم دايمًا حقوق النشر بتاعة المصدر الأصلي.

### الاستخدام

اتكلم مع Claude عادي:

> "ترجملي الصفحة دي وحولها PDF: https://example.com/some-article"
> "عايز أذاكر من اللينك ده بالعربي"
> "حول المقال ده لملف عربي أقدر أذاكر منه"

### ⚠️ ليه الـ skill ده موجود أصلًا (مشكلة الـ bidi)

النسخ الأولانية من الـ skill كانت بتترجم *كل* تعليق جوه الكود للعربي، حتى اللي فيه quotes أو رموز أو أسماء تقنية قصيرة مختلطة (زي `# استخدام "0-*" عشان تسيب Redis يولّد الـ sequence`). ده كان شكله عادي في المحرر، لكن بيطلع في الـ PDF **مقلوب بصريًا** — الكلمات بتظهر بترتيب غلط، لأن خوارزمية الـ Unicode Bidirectional Algorithm مش بتحل بشكل موثوق الحالات اللي فيها عربي (RTL) وكود/إنجليزي (LTR) فيه quotes أو رموز متداخلين جوه بلوك كود أصلًا LTR.

جرّبنا أكتر من حل (فصل الأسطر، استخدام Unicode isolate characters زي `U+2066`/`U+2069`) — ولا واحد فيهم كان موثوق 100% في كل الحالات. القاعدة اللي فعلًا شغالة:

> **لو الكومنت جوه الكود فيه عربي مختلط مع quotes أو رموز أو توكن تقني — سيبه بالإنجليزي بالكامل.** الشرح العربي أصلًا موجود في صندوق الشرح تحت الكود مباشرة، فمفيش أي فقدان للمعنى — والـ PDF بيفضل نضيف وسهل القراءة.

القاعدة دي متضمنة جوه `SKILL.md` عشان أي تشغيل جاي يتفاداها تلقائي.

### هيكل الريبو

```
translate-explain-pdf/
├── SKILL.md                  # تعليمات الـ skill اللي Claude بيتبعها
├── LICENSE                   # رخصة MIT
├── README.md
├── assets/
│   └── template.html         # قالب HTML/CSS عربي RTL (صناديق، عناوين، بلوكات كود)
├── scripts/
│   ├── setup.sh               # سكريبت إعداد البيئة بضغطة واحدة (آمن التكرار)
│   └── html_to_pdf.py        # سكريبت WeasyPrint لتحويل HTML لـ PDF
├── references/
│   └── design_notes.md       # مرجع الكلاسات + تفاصيل قاعدة الأمان من الـ bidi
├── evals/
│   └── manual_test_log.md    # اللي اتجرب، اللي اتكسر، وإزاي اتحل
└── universal/
    └── universal_prompt.md   # نسخة تشتغل مع أي موديل، من غير اشتراك، من غير تنفيذ كود
```

### القيود

- الصفحات الطويلة جدًا (كتب كاملة، مواقع توثيق ضخمة) الأفضل تتقسم لأكتر من طلب.
- جودة الناتج بتعتمد على مدى سهولة استخراج محتوى الصفحة الأصلية (مواقع JS-heavy ممكن تحتاج نسخ يدوي).
- ده أداة **للمذاكرة الشخصية** — احترم دايمًا حقوق النشر بتاعة المصدر الأصلي، ومتوزعش نسخ مترجمة كاملة من مقالات محمية بشكل عام.

---

<p align="center">Made for studying, not shortcuts. 📚</p>