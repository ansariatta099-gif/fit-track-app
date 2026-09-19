class FitnessAiEngine {
  /// Analyzes the user message and provides a detailed, encouraging, and actionable response.
  static String getResponse(String userMessage) {
    final lower = userMessage.toLowerCase().trim();

    final isRomanUrdu = _detectRomanUrdu(lower);

    // 1. Hydration
    if (_matchesAny(lower, ['hydration', 'water', 'paani', 'pani', 'liquid', 'drink'])) {
      return isRomanUrdu ? _getHydrationUrdu() : _getHydrationEnglish();
    }

    // 2. High Protein & Meal ideas
    if (_matchesAny(lower, ['protein', 'meal', 'diet', 'khana', 'food', 'breakfast', 'lunch', 'dinner', 'snack'])) {
      return isRomanUrdu ? _getProteinMealsUrdu() : _getProteinMealsEnglish();
    }

    // 3. Home Workouts / Workout Splits
    if (_matchesAny(lower, ['workout', 'exercise', 'split', 'home workout', 'kasrat', 'training', 'routine', 'push', 'pull', 'legs'])) {
      return isRomanUrdu ? _getWorkoutUrdu() : _getWorkoutEnglish();
    }

    // 4. Muscle Gain / Bulking
    if (_matchesAny(lower, ['muscle', 'gain', 'bulk', 'hypertrophy', 'dole', 'body banana', 'size'])) {
      return isRomanUrdu ? _getMuscleGainUrdu() : _getMuscleGainEnglish();
    }

    // 5. Weight Loss / Fat Loss / Cutting
    if (_matchesAny(lower, ['weight loss', 'fat loss', 'wazan kam', 'motapa', 'belly fat', 'pet kam', 'calorie deficit', 'cut'])) {
      return isRomanUrdu ? _getWeightLossUrdu() : _getWeightLossEnglish();
    }

    // 6. Greetings / Salutations
    if (_matchesAny(lower, ['hi', 'hello', 'hey', 'salam', 'assalam', 'kaise ho', 'kya haal'])) {
      return isRomanUrdu ? _getGreetingUrdu() : _getGreetingEnglish();
    }

    // 7. General Fitness Guidance (Fallback)
    return isRomanUrdu ? _getGeneralUrdu(userMessage) : _getGeneralEnglish(userMessage);
  }

  static bool _detectRomanUrdu(String text) {
    final urduKeywords = [
      'kya', 'kaise', 'karo', 'karein', 'karna', 'batao', 'chahiye', 'wazan',
      'paani', 'khana', 'kam', 'zyada', 'dole', 'bhook', 'hai', 'hain', 'mein',
      'mujhe', 'mera', 'meri', 'kuch', 'hoga', 'salam', 'shukriya', 'bhai'
    ];
    return urduKeywords.any((kw) => text.contains(kw));
  }

  static bool _matchesAny(String text, List<String> keywords) {
    return keywords.any((kw) => text.contains(kw));
  }

  // ==================== ENGLISH RESPONSES ====================

  static String _getHydrationEnglish() {
    return """💧 **Complete Hydration Guide for Fitness & Health**

Staying properly hydrated is essential for workout performance, muscle recovery, and fat loss!

### 1. Daily Water Intake Target
* **General Rule:** Aim for **35 to 40 ml per kg of body weight** daily.
* Example: If you weigh **70 kg**, your baseline target is **2.5 to 2.8 Liters** per day.

### 2. Workout Hydration Timing
* **Pre-Workout (2 hours before):** Drink **500 ml** of water to ensure your muscles are well hydrated.
* **Intra-Workout (During):** Take small sips (**150-200 ml every 15-20 minutes**). Avoid chugging large amounts at once.
* **Post-Workout:** Drink **500-700 ml** within 1 hour after training to replace sweat loss.

### 3. Electrolytes & Performance
* If you sweat heavily or workout intensely for over 45 minutes, add a pinch of Himalayan pink salt and lemon to your water to replenish **Sodium** and **Potassium**.

### 💡 Quick Coach Tips:
* Start your morning with **2 glasses of warm or room-temperature water** to kickstart your metabolism.
* Check your urine color: Pale straw yellow means optimal hydration!""";
  }

  static String _getProteinMealsEnglish() {
    return """🥩 **High Protein Meal Ideas for Maximum Muscle & Recovery**

To support muscle repair and keep you full, aim for **25-35g of protein per meal**.

### 🍳 Breakfast Options:
* **Egg Scramble:** 3 whole eggs + 2 egg whites with whole grain toast and spinach (~28g protein).
* **High-Protein Oatmeal:** 1 cup oats cooked in milk with 1 scoop protein powder or 2 tbsp peanut butter & chia seeds (~26g protein).

### 🥗 Lunch Options:
* **Grilled Chicken Breast (150g)** with 1 cup brown rice and steamed broccoli (~38g protein).
* **Paneer / Tofu Stir-Fry:** 150g grilled paneer/tofu with mixed bell peppers and quinoa (~25g protein).

### 🍲 Dinner Options:
* **Fish Fillet / Salmon:** Baked fish with roasted sweet potatoes and green beans (~35g protein).
* **Lentil / Dal Power Bowl:** 1.5 cups boiled chickpea or dal bowl with grilled cottage cheese (~28g protein).

### 🥜 Quick Protein Snacks:
* Boiled eggs (2 eggs = 12g protein)
* Greek Yogurt / Dahi (150g = 15g protein)
* Roasted chickpeas / Chana (1 cup = 15g protein)""";
  }

  static String _getWorkoutEnglish() {
    return """🏋️ **Effective Workout Guidance & Structure**

Consistency and progressive overload are the secrets to great physical transformations!

### 🏠 Best Home Workout Plan (Full Body):
Complete 3-4 rounds with 60 seconds rest between circuits:
1. **Push-Ups:** 10 - 15 reps (Chest & Triceps)
2. **Bodyweight Squats:** 15 - 20 reps (Quads & Glutes)
3. **Pike Push-Ups or Wall Handstand Hold:** 8 - 12 reps (Shoulders)
4. **Walking Lunges:** 12 reps per leg (Legs & Balance)
5. **Chair / Bench Dips:** 12 - 15 reps (Triceps)
6. **Plank Hold:** 45 - 60 seconds (Core stability)

### 🏢 4-Day Gym Split (Upper / Lower):
* **Day 1 (Upper Body):** Bench Press, Barbell Rows, Overhead Press, Lat Pulldowns.
* **Day 2 (Lower Body):** Squats, Romanian Deadlifts, Leg Press, Calf Raises.
* **Day 3:** Rest / Light Cardio.
* **Day 4 (Upper Body Hypertrophy):** Incline Dumbbell Press, Pull-ups, Lateral Raises, Bicep Curls.
* **Day 5 (Lower Body Hypertrophy):** Deadlifts, Lunges, Leg Curls, Core workout.

### 💡 Pro Tip:
Always spend 5 minutes on a dynamic warm-up before lifting to protect your joints!""";
  }

  static String _getMuscleGainEnglish() {
    return """📈 **Ultimate Muscle Gain & Hypertrophy Guide**

To build quality lean muscle mass without gaining excess fat, follow these core pillars:

1. **Slight Calorie Surplus:** Eat **250 - 400 calories** above your maintenance level every day.
2. **Protein Target:** Consume **1.6 to 2.2 grams of protein per kg of body weight** (e.g., 70kg person = 120-150g daily).
3. **Progressive Overload:** Every week, aim to increase weight, reps, or improve form on your key compound lifts.
4. **Rep Range:** Target **8 to 12 repetitions** per set, pushing within 1-2 reps of muscular failure.
5. **Rest & Sleep:** Muscles grow while resting! Ensure **7 to 9 hours of quality sleep** each night.""";
  }

  static String _getWeightLossEnglish() {
    return """🔥 **Smart Fat Loss & Weight Management Strategy**

Sustainable fat loss comes from a manageable calorie deficit combined with strength training.

### Key Rules:
1. **Moderate Calorie Deficit:** Eat **300 - 500 calories below** your maintenance calories. This leads to safe fat loss of ~0.5kg per week.
2. **Prioritize Protein:** Eat high protein with every meal to protect your existing muscle mass and control hunger.
3. **Daily Step Count (NEAT):** Aim for **8,000 to 10,000 steps daily**. Walking burns fat without creating fatigue.
4. **Strength Training:** Lift weights 3-4 times a week. Building muscle naturally increases your resting metabolic rate.
5. **Cut Liquid Calories:** Avoid sugary sodas, sweetened teas, and excess fruit juices. Drink water, black coffee, or green tea instead.""";
  }

  static String _getGreetingEnglish() {
    return """👋 Hello! I am your **FitTrack AI Coach** 🤖.

I'm here to help you crush your fitness goals! You can ask me about:
* 🏋️ **Workout plans** (Home routines, gym splits, form checks)
* 🍎 **Nutrition & Meals** (High protein recipes, calorie targets)
* 💧 **Hydration guidance**
* 📉 **Fat loss or muscle gain strategies**

What would you like to focus on today?""";
  }

  static String _getGeneralEnglish(String query) {
    return """💪 **FitTrack AI Coach Advice**

Regarding your question: *"$query"*

Here is what I recommend for your daily routine:
1. **Consistency over perfection:** Prioritize small, daily habits like hitting your daily step goal and drinking enough water.
2. **Fuel your body:** Focus on whole foods, lean proteins, and complex carbohydrates to keep your energy steady.
3. **Recovery:** Give your body at least 1-2 rest days per week to let your muscles recover and prevent injuries.

Tell me a bit more about your current goal (e.g., weight loss, muscle gain, home or gym workout) so I can give you a personalized plan!""";
  }

  // ==================== ROMAN URDU RESPONSES ====================

  static String _getHydrationUrdu() {
    return """💧 **Hydration & Paani Peene Ki Mukammal Guidance**

FitTrack AI Coach ki taraf se aap ke liye hydration guide:

### 1. Rozana Kitna Paani Peena Chahiye?
* **Formula:** Apne wazan ke mutabiq **35 se 40 ml per kg** paani daily piyein.
* Misal ke tor par: Agar aapka wazan **70 kg** hai, to kam az kam **2.5 se 3 Litres** paani rozana zaroori hai.

### 2. Workout Ke Dauran Paani Ka Schedule
* **Workout se 2 ghante pehle:** 500 ml (2 glass) paani piyein taake body well-hydrated rahe.
* **Workout ke dauran:** Har 15-20 minute baad 2-3 ghoont (sip) piyein. Ek dam bohot zyada paani na piyein.
* **Workout ke baad:** Agle 1 ghante mein 500-700 ml paani piyein taake pasine ki kami poori ho sake.

### 💡 Coach Tip:
Subah uth kar sabse pehle 1-2 glass taaza paani piyein. Is se metabolism tez hota hai aur energy boost milti hai!""";
  }

  static String _getProteinMealsUrdu() {
    return """🥩 **High Protein Diet & Desi Khano Ki Guide**

Muscle banane aur fat kam karne ke liye protein sabse zaroori hai!

### 🍳 Subah Ka Nashta (Breakfast):
* **3 Ande (Eggs):** 2 poore ande + 1 egg white + Brown bread / Paratha (bina zyada oil ke) (~18g protein).
* **Oats / Daliya:** Doodh mein paka hua daliya + 1 chammach Peanut Butter (~15g protein).

### 🥗 Dopahar Ka Khana (Lunch):
* **Chicken Breast / Boneless Chicken (150g):** Sath mein 1 roti ya thode chawal aur bohot saara salad (~35g protein).
* **Dal ya Chana Bowl:** 1 bada cup safaid chane ya daal + dahi (yogurt) (~20g protein).

### 🍲 Raat Ka Khana (Dinner):
* **Fish ya Grilled Chicken:** Sath mein sabziyan (Veggies) (~30g protein).
* **Paneer Bhurji / Daal:** Agar vegetarian hain to Paneer ya soya chunks best options hain.

### 🥜 Healthy Snacks:
* 2 ubale hue ande (12g protein)
* 1 mutthi roasted chane (roasted chickpeas)
* Dahi (Yogurt) with fruit""";
  }

  static String _getWorkoutUrdu() {
    return """🏋️ **Workout Guidance & Routine Plans**

Chahe aap ghar par workout karein ya gym mein, ye routine follow karein:

### 🏠 Ghar Par Full Body Workout (Bina Saman Ke):
Har exercise ke 3 sets karein:
1. **Push-Ups:** 10-15 reps (Chest aur Triceps ke liye)
2. **Bodyweight Squats:** 15-20 reps (Tango aur Legs ke liye)
3. **Pike Push-ups / Chair Dips:** 12 reps (Shoulders aur Triceps)
4. **Lunges:** 12 reps har taang par (Legs aur balance)
5. **Plank Hold:** 45 seconds (Pet aur Core ke liye)

### 💡 Golden Rules:
* Workout se pehle 5 minute warm-up zaroor karein.
* Har set ke darmiyan 60-90 seconds ka rest lein.
* Consistency sabse ahem hai — hafte mein 4-5 din zaroor workout karein!""";
  }

  static String _getMuscleGainUrdu() {
    return """📈 **Muscle Gain & Wazan Barhane Ka Tariqa**

Clean muscle mass banane ke liye ye 4 baaton par amal karein:

1. **Zyada Calories Khayein:** Apni daily zaroorat se **300-400 calories zyada** khayein (Calorie Surplus).
2. **Protein Zaroori Hai:** Rozana kam az kam **1.6 se 2g protein per kg wazan** lein (e.g. 70kg wazan to 120g protein).
3. **Wazan Barhate Rahein (Progressive Overload):** Har hafte thoda wazan ya reps barhane ki koshish karein.
4. **Puri Neend:** Muscles gym mein nahi bante, jab aap sote hain tab bante hain! **7-8 ghante ki neend** lazmi lein.""";
  }

  static String _getWeightLossUrdu() {
    return """🔥 **Wazan Aur Charbi (Fat) Kam Karne Ka Sahi Formula**

1. **Calorie Deficit:** Apni zaroorat se **300-500 calories kam** khayein. Bhooka nahi rehna, balki healthy khana hai!
2. **Meethi cheezein band karein:** Soft drinks, juices, aur bakery items avoid karein.
3. **Rozana 8,000 - 10,000 steps:** Paidal chalne se charbi bohot tezi se kam hoti hai.
4. **High Protein Khayein:** Protein se bhook kam lagti hai aur muscle bacha rehta hai.
5. **Sabziyan aur Paani:** Khane se pehle 1 glass paani piyein aur plate mein aadha hissa salad rakhein.""";
  }

  static String _getGreetingUrdu() {
    return """Assalam-o-Alaikum! Main aapka **FitTrack AI Coach** 🤖 hoon.

Main aapki fitness aur nutrition mein poori madad karunga. Aap mujhse pooch sakte hain:
* 🏋️ **Workout routines** (Ghar ya gym ka plan)
* 🍎 **Diet plans aur Protein khane**
* 💧 **Paani peene ka schedule**
* 📉 **Wazan kam karna ya muscle banana**

Aaj aap kya shuru karna chahte hain?""";
  }

  static String _getGeneralUrdu(String query) {
    return """💪 **FitTrack AI Coach Advice**

Aapke sawal: *"$query"* ke mutabiq meri advice ye hai:

1. **Habit Banayein:** Fitness ek din ka kaam nahi hai. Rozana thoda thoda behtar banein.
2. **Khane Par Dhyan Dein:** Ghar ka saaf khana, kam tel (oil), aur zyada protein lein.
3. **Water & Sleep:** Paani khoob piyein aur 7-8 ghante ki pur-sukoon neend lein.

Aap apna specific goal bataiye (maslan wazan kam karna hai ya muscle banana hai), taake main aapke liye mukammal plan tayar kar sakoon!""";
  }
}
