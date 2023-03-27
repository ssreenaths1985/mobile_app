import '../../models/index.dart';
import './app_constants.dart';

const ASSESSMENT_QUESTIONS = const [
  AssessmentQuestion(
    id: 1,
    question: 'What is the duration of the scrum sprint?',
    options: ['1 week', '2 weeks', '3 weeks', 'None of these'],
    questionType: QuestionTypes.singleAnswer,
  ),
  AssessmentQuestion(
    id: 2,
    question: 'Select only agile framework',
    options: ['Scrum', 'Kaizen', 'Kanban', 'Pokeyoke'],
    questionType: QuestionTypes.multipleAnswer,
  ),
  AssessmentQuestion(
    id: 3,
    question: 'What is the duration of the scrum sprint?',
    options: ['Fast', 'Flexible', 'Frequent', 'Fixed'],
    questionType: QuestionTypes.singleAnswer,
  ),
];
