import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../home/domain/news.dart';

part 'news_provider.g.dart';

List<News> allNews = [
News(imageUrl: 'https://via.placeholder.com/150x200', title: 'Ser donante voluntario', paper: 'REPORTE 2820', subtitle: 'Desde el Hospital Centenario recalcan la importancia de la donación voluntaria de Sangre', content: 'En un esfuerzo por concienciar sobre la necesidad constante de sangre y sus componentes, el Hospital Centenario destaca la importancia de convertirse en un donante voluntario. La donación de sangre es un acto solidario y altruista que puede salvar vidas y mejorar la salud de aquellos que enfrentan enfermedades graves o accidentes.\n La donación voluntaria de sangre desempeña un papel vital en el sistema de salud. A diferencia de la donación de sangre por reposición, donde se solicita a familiares y amigos donar para un paciente específico, la donación voluntaria se realiza sin ninguna conexión directa con un receptor particular. Esto garantiza un suministro constante y seguro de sangre y productos sanguíneos para todos aquellos que lo necesiten.\n Los beneficios de ser donante voluntario son numerosos. Además de la satisfacción de ayudar a quienes más lo necesitan, la donación de sangre tiene beneficios para la salud del propio donante. Al donar sangre, se realiza un chequeo médico que incluye pruebas para detectar enfermedades transmisibles, lo que puede proporcionar una evaluación temprana y ayuda en el diagnóstico de posibles problemas de salud.'),
News(imageUrl: 'https://via.placeholder.com/150x200', title: 'Juntamos residuos', paper: 'NOTICIAS DE CUYO', subtitle: 'Voluntarios de Godoy Cruz, se sumaron a la limpieza de un cauce  en las inmediaciones.', content: ''),
News(imageUrl: 'https://via.placeholder.com/150x200', title: 'Adoptar mascotas', paper: 'DIARIO LA NACIóN', subtitle: 'Ayudanos a limpiar las calles de perros callejeros adoptándolos evitando la sobrepoblación de las perreras.', content: ''),
News(imageUrl: 'https://via.placeholder.com/150x200', title: 'Preservamos la fauna', paper: 'LA VOZ DEL INTERIOR', subtitle: 'Córdoba se une a la campaña del gobierno cuidar la fauna en época de sequía', content: ''),
];

@riverpod
List<News> news(ref) {
  return allNews;
}