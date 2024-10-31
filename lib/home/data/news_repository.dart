import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/news.dart';

class NewsRepository{
  final FirebaseFirestore _firestore;

  NewsRepository(this._firestore);

  Future<List<News>> fetchNews() async {
    final newsJson = await _firestore.collection('news').get();
    List<News> news = [];
    for (var newsDoc in newsJson.docs) {
      news.add(News.fromJson(newsDoc.data()));
    }
    return news;
  }

  // TODO: uncomment this method to upload news
  // List<News> allNews = [
  //   News(
  //       imageUrl: 'https://s3-alpha-sig.figma.com/img/839a/009b/380a4b7407209dad0aeec257c6df7298?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=bbASLjeMDA5lUlPRAmIx7Zo0xXtwflg~~qwmt81trnU1Z86AxqHJjtA-2MRbMttjvZEQNBB5NkBZqpcZjCuPAuArPLAxTapIXauw8oIh5ukX089qGOvs9OBfmjs21xUj8EfdtJmPtMmnQZ8M6K5lexmg0K-rTnkpXvqBZJdAXWws9XOGuoiWAebGoqsusSYP4QlKiRH1xzIhNEKySq0RiZ2~2C8x9YUh3uPpj4dIG-9vF7gLvnVCkvznJPStUdfNui-WDuejU6ubZ1eOj3Wtl6k9rV2Q44dowXM4w7CucZZkuwbsaBhGm-ZC2yfxBRmg6zdOqg9e9cF0a3c6Kx-vww__',
  //       title: 'Ser donante voluntario',
  //       paper: 'REPORTE 2820',
  //       creationDate: DateTime.now(),
  //       subtitle:
  //       'Desde el Hospital Centenario recalcan la importancia de la donación voluntaria de Sangre',
  //       content:
  //       'En un esfuerzo por concienciar sobre la necesidad constante de sangre y sus componentes, el Hospital Centenario destaca la importancia de convertirse en un donante voluntario. La donación de sangre es un acto solidario y altruista que puede salvar vidas y mejorar la salud de aquellos que enfrentan enfermedades graves o accidentes.\n La donación voluntaria de sangre desempeña un papel vital en el sistema de salud. A diferencia de la donación de sangre por reposición, donde se solicita a familiares y amigos donar para un paciente específico, la donación voluntaria se realiza sin ninguna conexión directa con un receptor particular. Esto garantiza un suministro constante y seguro de sangre y productos sanguíneos para todos aquellos que lo necesiten.\n Los beneficios de ser donante voluntario son numerosos. Además de la satisfacción de ayudar a quienes más lo necesitan, la donación de sangre tiene beneficios para la salud del propio donante. Al donar sangre, se realiza un chequeo médico que incluye pruebas para detectar enfermedades transmisibles, lo que puede proporcionar una evaluación temprana y ayuda en el diagnóstico de posibles problemas de salud.'),
  //   News(
  //       imageUrl: 'https://s3-alpha-sig.figma.com/img/9d9d/8b2b/1b4848e87872562e2c1a855aa6f6ff14?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qhp0GwLTvwJPEkb-YluHY341HwiYWT84iaobNP5oj5fSHCUDG5sQsjVTJc-QsEtrWRxiCNIDZfQ7m7Fc6Ag0t~I2LX83FndJ6U2JPpduMZdnYbRFMX33-UTbpChs8VWdxqLiE8mk-9ecJ-w52~A0VQOwLynmzVmBKKu1HHAOCd~HnBYljNVB97OibrIFtPo~YtuPwgl5-gmXxJQE~IIlaA0Z5zfH2ga2WJlHyH5Jr2WBkPUobj1ZbV~CX8FQcYvkNqkwjClcTexjhJSbCRh0H1~5kWVF0wxDBgcK7lMMFBkwpbVBXdm4kSojCzeEa-sIaVkizkn4f7UrjnZ869Fq6Q__',
  //       title: 'Juntamos residuos',
  //       paper: 'NOTICIAS DE CUYO',
  //       //yesterday
  //       creationDate: DateTime.now().subtract(const Duration(days: 1)),
  //       subtitle:
  //       'Voluntarios de Godoy Cruz, se sumaron a la limpieza de un cauce  en las inmediaciones.',
  //       content: ''),
  //   News(
  //       imageUrl: 'https://s3-alpha-sig.figma.com/img/614a/f89d/ddcf837280c90c026e0b41672fbd114a?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=iNd8DtGFst6hB-MV8zcHezoBbUt0PXmkO51T-gQm-4dPUV3G6qUdzsqeYyjNxtUylOrLybKMKuIZXIkcg7MT7cgWT9D0ZRY9NVzTGw76t-sARW35Cm7ouZ~axtoiU4KGm0~BT3OCIVUlg1ssPMAsxo8twj8LhubkIlSsc6KIYtIbc44p8wdgUw-EkFKpaN1Qx-RSiuMhx9bvxCPgP5qTImDMNomSahWmqirZOjak-0IVk2b1B-awvIqAS8ANoATXdZbLi0gLAmu9RVYtBnFfjuk5SIrtUAvRJgYijPBoP7dndN66kVuJ2Y4NMjdXUf8SuI8lIM-TL6nB~BsK2q40zg__',
  //       title: 'Adoptar mascotas',
  //       paper: 'DIARIO LA NACIóN',
  //       creationDate: DateTime.now().subtract(const Duration(days: 5)),
  //       subtitle:
  //       'Ayudanos a limpiar las calles de perros callejeros adoptándolos evitando la sobrepoblación de las perreras.',
  //       content: ''),
  //   News(
  //       imageUrl: 'https://s3-alpha-sig.figma.com/img/bf1c/454a/07b44933fe080e986551bc68e44ac23c?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=PW98UA-MCNyhnSPAKKf64Ltym7t5c3YP2m-FFZkhYqItRtlKba5CEV5I9JdGLMqOJRh6ncwMnZxZAsv5LYZYbGbMqOmnts-JPS1tWmoJC7GV7Rl75cjF7REAgyQ-WuxubmVCmfWo9I36oa6UUEPknMGcwj3~BiU136q0CIBLo11M8RXTR08u9FQVv1XeRIgp~Z5tF1Dbz~yUdBw3DW~GQq-2GmIFV16SQE57GsbnzsbIOzySxhwLWmcYYAaWej-BeZN0swcmwRMmHsmtvaUZADdAFHxFp0RGjQ~HUqg-4A3wZJXKkbRVdZavACyQKFQ1K9ByDUZVQA-5LrsyfMSVBw__',
  //       title: 'Preservamos la fauna',
  //       paper: 'LA VOZ DEL INTERIOR',
  //       creationDate: DateTime.now().subtract(const Duration(days: 2)),
  //       subtitle:
  //       'Córdoba se une a la campaña del gobierno cuidar la fauna en época de sequía',
  //       content: ''),
  // ];
  //
  // void uploadNews() {
  //   for (var news in allNews) {
  //     _firestore.collection('news').add(news.toJson());
  //   }
  // }
}