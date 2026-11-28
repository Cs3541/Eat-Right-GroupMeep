import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class IngredientModel {
  final String name;
  final double serving_size_g;
  final double calories;
  final double total_fat_g;
  
  final double alanine_g;
  final double alcohol_g;
  final double arginine_g;
  final double ash_g;
  final double aspartic_acid_g;
  final double caffeine_mg;
  final double calcium_mg;
  final double carbohydrate_g;
  final double carotene_alpha_mcg;
  final double carotene_beta_mcg;
  final double cholesterol_mg;
  final double choline_mg;
  final double copper_mg;
  final double cryptoxanthin_beta_mcg;
  final double cystine_g;
  final double fat_g;
  final double fatty_acids_total_trans_mg;
  final double fiber_g;
  final double folate_mcg;
  final double folic_acid_mcg;
  final double fructose_g;
  final double galactose_g;
  final double glucose_g;
  final double glutamic_acid_g;
  final double glycine_g;
  final double histidine_g;
  final double hydroxyproline_g;
  final double irom_mg;
  final double isoleucine_g;
  final double lactose_g;
  final double leucine_g;
  final double lutein_zeaxanthin_mcg;
  final double lysine_g;
  final double magnesium_mg;
  final double maltose_g;
  final double manganese_mg;
  final double methionine_g;
  final double monounsaturated_fatty_acids_g;
  final double niacin_mg;
  final double pantothenic_acid_mg;
  final double phenylalanine_g;
  final double phosphorous_mg;
  final double polyunsaturated_fatty_acids_g;
  final double potassium_mg;
  final double proline_g;
  final double protein_g;
  final double riboflavin_mg;
  final double saturated_fat_g;
  final double saturated_fatty_acids_g;
  final double selenium_mcg;
  final double serine_g;
  final double sodium_mg;
  final double sucrose_g;
  final double sugars_g;
  final double theobromine_mg;
  final double thiamin_mg;
  final double threonine_g;
  final double tocopherol_alpha_mg;
  final double tryptophan_g;
  final double tyrosine_g;
  final double valine_g;
  final double vitamin_a_IU;
  final double vitamin_a_rae_mcg;
  final double vitamin_b6_mg;
  final double vitamin_b12_mcg;
  final double vitamin_c_mg;
  final double vitamin_d_IU;
  final double vitamin_e_mg;
  final double vitamin_k_mcg;
  final double water_g;
  final double zink_mg;

  IngredientModel({
    required this.name,
    required this.calories,
    required this.serving_size_g,
    required this.total_fat_g,
    
    required this.alanine_g,
    required this.alcohol_g,
    required this.arginine_g,
    required this.ash_g,
    required this.aspartic_acid_g,
    required this.caffeine_mg,
    required this.calcium_mg,
    required this.carbohydrate_g,
    required this.carotene_alpha_mcg,
    required this.carotene_beta_mcg,
    required this.cholesterol_mg,
    required this.choline_mg,
    required this.copper_mg,
    required this.cryptoxanthin_beta_mcg,
    required this.cystine_g,
    required this.fat_g,
    required this.fatty_acids_total_trans_mg,
    required this.fiber_g,
    required this.folate_mcg,
    required this.folic_acid_mcg,
    required this.fructose_g,
    required this.galactose_g,
    required this.glucose_g,
    required this.glutamic_acid_g,
    required this.glycine_g,
    required this.histidine_g,
    required this.hydroxyproline_g,
    required this.irom_mg,
    required this.isoleucine_g,
    required this.lactose_g,
    required this.leucine_g,
    required this.lutein_zeaxanthin_mcg,
    required this.lysine_g,
    required this.magnesium_mg,
    required this.maltose_g,
    required this.manganese_mg,
    required this.methionine_g,
    required this.monounsaturated_fatty_acids_g,
    required this.niacin_mg,
    required this.pantothenic_acid_mg,
    required this.phenylalanine_g,
    required this.phosphorous_mg,
    required this.polyunsaturated_fatty_acids_g,
    required this.potassium_mg,
    required this.proline_g,
    required this.protein_g,
    required this.riboflavin_mg,
    required this.saturated_fat_g,
    required this.saturated_fatty_acids_g,
    required this.selenium_mcg,
    required this.serine_g,
    required this.sodium_mg,
    required this.sucrose_g,
    required this.sugars_g,
    required this.theobromine_mg,
    required this.thiamin_mg,
    required this.threonine_g,
    required this.tocopherol_alpha_mg,
    required this.tryptophan_g,
    required this.tyrosine_g,
    required this.valine_g,
    required this.vitamin_a_IU,
    required this.vitamin_a_rae_mcg,
    required this.vitamin_b6_mg,
    required this.vitamin_b12_mcg,
    required this.vitamin_c_mg,
    required this.vitamin_d_IU,
    required this.vitamin_e_mg,
    required this.vitamin_k_mcg,
    required this.water_g,
    required this.zink_mg,
  });

  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<List<IngredientModel>> fetchIngredients() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final snapshot = await _firestore
      .collection('nutrition')
      // .where('name', isEqualTo: name)
      .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return IngredientModel(
        name: doc.id,
        calories: (data['calories'] as num).toDouble(),
        total_fat_g: (data['total_fat_g'] as num).toDouble(),
        serving_size_g: (data['serving_size_g'] as num).toDouble(),

        alanine_g: (data['alanine_g'] as num).toDouble(),
        alcohol_g: (data['alcohol_g'] as num).toDouble(),
        arginine_g: (data['arginine_g'] as num).toDouble(),
        ash_g: (data['ash_g'] as num).toDouble(),
        aspartic_acid_g: (data['aspartic_acid_g'] as num).toDouble(),
        caffeine_mg: (data['caffeine_mg'] as num).toDouble(),
        calcium_mg: (data['calcium_mg'] as num).toDouble(),
        carbohydrate_g: (data['carbohydrate_g'] as num).toDouble(),
        carotene_alpha_mcg: (data['carotene_alpha_mcg'] as num).toDouble(),
        carotene_beta_mcg: (data['carotene_beta_mcg'] as num).toDouble(),
        cholesterol_mg: (data['cholesterol_mg'] as num).toDouble(),
        choline_mg: (data['choline_mg'] as num).toDouble(),
        copper_mg: (data['copper_mg'] as num).toDouble(),
        cryptoxanthin_beta_mcg: (data['cryptoxanthin_beta_mcg'] as num).toDouble(),
        cystine_g: (data['cystine_g'] as num).toDouble(),
        fat_g: (data['fat_g'] as num).toDouble(),
        fatty_acids_total_trans_mg: (data['fatty_acids_total_trans_mg'] as num).toDouble(),
        fiber_g: (data['fiber_g'] as num).toDouble(),
        folate_mcg: (data['folate_mcg'] as num).toDouble(),
        folic_acid_mcg: (data['folic_acid_mcg'] as num).toDouble(),
        fructose_g: (data['fructose_g'] as num).toDouble(),
        galactose_g: (data['galactose_g'] as num).toDouble(),
        glucose_g: (data['glucose_g'] as num).toDouble(),
        glutamic_acid_g: (data['glutamic_acid_g'] as num).toDouble(),
        glycine_g: (data['glycine_g'] as num).toDouble(),
        histidine_g: (data['histidine_g'] as num).toDouble(),
        hydroxyproline_g: (data['hydroxyproline_g'] as num).toDouble(),
        irom_mg: (data['irom_mg'] as num).toDouble(),
        isoleucine_g: (data['isoleucine_g'] as num).toDouble(),
        lactose_g: (data['lactose_g'] as num).toDouble(),
        leucine_g: (data['leucine_g'] as num).toDouble(),
        lutein_zeaxanthin_mcg: (data['lutein_zeaxanthin_mcg'] as num).toDouble(),
        lysine_g: (data['lysine_g'] as num).toDouble(),
        magnesium_mg: (data['magnesium_mg'] as num).toDouble(),
        maltose_g: (data['maltose_g'] as num).toDouble(),
        manganese_mg: (data['manganese_mg'] as num).toDouble(),
        methionine_g: (data['methionine_g'] as num).toDouble(),
        monounsaturated_fatty_acids_g: (data['monounsaturated_fatty_acids_g'] as num).toDouble(),
        niacin_mg: (data['niacin_mg'] as num).toDouble(),
        pantothenic_acid_mg: (data['pantothenic_acid_mg'] as num).toDouble(),
        phenylalanine_g: (data['phenylalanine_g'] as num).toDouble(),
        phosphorous_mg: (data['phosphorous_mg'] as num).toDouble(),
        polyunsaturated_fatty_acids_g: (data['polyunsaturated_fatty_acids_g'] as num).toDouble(),
        potassium_mg: (data['potassium_mg'] as num).toDouble(),
        proline_g: (data['proline_g'] as num).toDouble(),
        protein_g: (data['protein_g'] as num).toDouble(),
        riboflavin_mg: (data['riboflavin_mg'] as num).toDouble(),
        saturated_fat_g: (data['saturated_fat_g'] as num).toDouble(),
        saturated_fatty_acids_g: (data['saturated_fatty_acids_g'] as num).toDouble(),
        selenium_mcg: (data['selenium_mcg'] as num).toDouble(),
        serine_g: (data['serine_g'] as num).toDouble(),
        sodium_mg: (data['sodium_mg'] as num).toDouble(),
        sucrose_g: (data['sucrose_g'] as num).toDouble(),
        sugars_g: (data['sugars_g'] as num).toDouble(),
        theobromine_mg: (data['theobromine_mg'] as num).toDouble(),
        thiamin_mg: (data['thiamin_mg'] as num).toDouble(),
        threonine_g: (data['threonine_g'] as num).toDouble(),
        tocopherol_alpha_mg: (data['tocopherol_alpha_mg'] as num).toDouble(),
        tryptophan_g: (data['tryptophan_g'] as num).toDouble(),
        tyrosine_g: (data['tyrosine_g'] as num).toDouble(),
        valine_g: (data['valine_g'] as num).toDouble(),
        vitamin_a_IU: (data['vitamin_a_IU'] as num).toDouble(),
        vitamin_a_rae_mcg: (data['vitamin_a_rae_mcg'] as num).toDouble(),
        vitamin_b6_mg: (data['vitamin_b6_mg'] as num).toDouble(),
        vitamin_b12_mcg: (data['vitamin_b12_mcg'] as num).toDouble(),
        vitamin_c_mg: (data['vitamin_c_mg'] as num).toDouble(),
        vitamin_d_IU: (data['vitamin_d_IU'] as num).toDouble(),
        vitamin_e_mg: (data['vitamin_e_mg'] as num).toDouble(),
        vitamin_k_mcg: (data['vitamin_k_mcg'] as num).toDouble(),
        water_g: (data['water_g'] as num).toDouble(),
        zink_mg: (data['zink_mg'] as num).toDouble(),
      );
      }).toList();
    }
}