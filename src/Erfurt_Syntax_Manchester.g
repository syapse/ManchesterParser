grammar Erfurt_Syntax_Manchester;

options {
  language  = python2;
//  backtrack = true;
//  memoize   = true;
}

import ManchesterTokenizer;

description returns [$value]
//@init{
//$ce = new Erfurt_Owl_Structured_ClassExpression();
//}
//@after{
//  if(count($ce->getElements())>1)
//    $value = new Erfurt_Owl_Structured_ClassExpression_ObjectUnionOf($ce->getElements());
//  else {
//    $e = $ce->getElements();
//    $value = $e[0];
//  }
//}
  :
  c1=conjunction
        (OR_LABEL c2=conjunction )*
  ;

conjunction returns [$value]
//@init{
//$ce = new Erfurt_Owl_Structured_ClassExpression();
//}
//@after{
//  if(count($ce->getElements())>1)
//    $value = new Erfurt_Owl_Structured_ClassExpression_ObjectIntersectionOf($ce->getElements());
//   else {
//    $e = $ce->getElements();
//    $value = $e[0];
//   }
//}
  :
  (c=classIRI THAT_LABEL )? p1=primary
    (AND_LABEL p2=primary )*
  ;

primary returns [$value]
  :
  (n=NOT_LABEL)? (v=restriction | v=atomic)
  ;

iri returns [$value]
//@after {
//$value = new Erfurt_Owl_Structured_Iri($v.text);
//}
  :
  v=FULL_IRI
  | v=ABBREVIATED_IRI
  | v=SIMPLE_IRI
  ;

objectPropertyExpression returns [$value]
//@after
  :
  v=objectPropertyIRI
  | v=inverseObjectProperty
  ;

restriction returns [$value]
  :
  o=objectPropertyExpression
    ((SOME_LABEL p=primary )
    | (ONLY_LABEL p=primary )
    | (VALUE_LABEL i=individual )
    | (SELF_LABEL )
    | (MIN_LABEL nni=nonNegativeInteger p=primary)
    | (MAX_LABEL nni=nonNegativeInteger p=primary)
    | (EXACTLY_LABEL nni=nonNegativeInteger p=primary)
  )
  | dp=dataPropertyExpression(
    (SOME_LABEL d=dataRange )
  | (ONLY_LABEL d=dataRange )
  | (VALUE_LABEL l=literal)
  | (MIN_LABEL nni=nonNegativeInteger d=dataRange? )
  | (MAX_LABEL nni=nonNegativeInteger d=dataRange? )
  | (EXACTLY_LABEL nni=nonNegativeInteger d=dataRange? )
        )
 // unreachable??? 
//  | (o=objectPropertyExpression MIN_LABEL nni=nonNegativeInteger) 
//  | (o=objectPropertyExpression MAX_LABEL nni=nonNegativeInteger) 
  //| (o=objectPropertyExpression EXACTLY_LABEL nni=nonNegativeInteger) 
  ;

atomic returns [$value]
  :
  classIRI 
  | OPEN_CURLY_BRACE individualList CLOSE_CURLY_BRACE 
  | OPEN_BRACE description CLOSE_BRACE 
  ;

classIRI returns [$value]
  :
  iri 
  ;

individualList returns [$value]
  :
  i=individual 
    (COMMA i1=individual )*
  ;

individual returns [$value]
  :
  i=individualIRI 
  | NODE_ID 
  ;

nonNegativeInteger returns [$value]
  :
  DIGITS 
  ;

dataPrimary returns [$value]
  :
  (n=NOT_LABEL)? dataAtomic
  ;

dataPropertyExpression returns [$value]
  :
  d=dataPropertyIRI 
  ;

dataAtomic returns [$value]
  :
  (dataType )
  | (OPEN_CURLY_BRACE literalList CLOSE_CURLY_BRACE )
  | (dataTypeRestriction )
  | (OPEN_BRACE dataRange CLOSE_BRACE )
  ;

literalList returns [$value]
  :
  l1=literal 
  (COMMA l2=literal )*
  ;

dataType returns [$value]
  :
  datatypeIRI 
  | v=INTEGER_LABEL  
  | v=DECIMAL_LABEL 
  | v=FLOAT_LABEL 
  | v=STRING_LABEL 
  ;

literal returns [$value]
//@after
  :
  v=typedLiteral | v=stringLiteralNoLanguage | v=stringLiteralWithLanguage | v=integerLiteral | v=decimalLiteral | v=floatingPointLiteral
  ;

stringLiteralNoLanguage returns [$value]
  :
  QUOTED_STRING
  ;

stringLiteralWithLanguage returns [$value]
  :
  QUOTED_STRING LANGUAGE_TAG 
  ;

lexicalValue returns [$value]
  :
  QUOTED_STRING 
  ;

typedLiteral returns [$value]
  :
  lexicalValue REFERENCE dataType 
  ;

restrictionValue returns [$value]
  :
  literal 
  ;

inverseObjectProperty returns [$value]
  :
  INVERSE_LABEL objectPropertyIRI
  ;

decimalLiteral returns [$value]
  :
  DLITERAL_HELPER 
  ;

integerLiteral returns [$value]
  : (i=ILITERAL_HELPER | i=DIGITS) 
  ;

floatingPointLiteral returns [$value]
  :
  FPLITERAL_HELPER 
  ;

objectProperty returns [$value]
  :
  objectPropertyIRI 
  ;

dataProperty returns [$value]
  :
  dataPropertyIRI 
  ;

dataPropertyIRI returns [$value]
  :
  iri 
  ;

datatypeIRI returns [$value]
  :
  iri 
  ;

objectPropertyIRI returns [$value]
  :
  iri 
  ;

dataTypeRestriction returns [$value]
  :
  dataType  OPEN_SQUARE_BRACE
        ( f=facet r=restrictionValue  COMMA?)+
  CLOSE_SQUARE_BRACE
  ;

individualIRI returns [$value]
  :
  iri 
  ;

datatypePropertyIRI returns [$value]
  :
  iri 
  ;

facet returns [$value]
//@after
  :
  v=LENGTH_LABEL | v=MIN_LENGTH_LABEL | v=MAX_LENGTH_LABEL | v=PATTERN_LABEL | v=LANG_PATTERN_LABEL | v=LESS_EQUAL | v=LESS | v=GREATER_EQUAL | v=GREATER
  ;

dataRange returns [$value]
//@init
//@after{
//  if(count($retval)>1) $value = new Erfurt_Owl_Structured_DataRange_DataUnionOf($retval);
//  else $value = $retval[0];
//}
  :
  d1=dataConjunction
        (OR_LABEL d2=dataConjunction )*
  ;

dataConjunction returns [$value]
//@init
//@after{
//  if(count($retval)>1) $value = new Erfurt_Owl_Structured_DataRange_DataIntersectionOf($retval);
//  else $value = $retval[0];
//}
  :
  d1=dataPrimary
            (AND_LABEL d2=dataPrimary)*
  ;

///////
// full mos
//
//annotationAnnotatedList returns [$value]
//	:	annotations? annotation (COMMA annotations? annotation)*
//	;
//
//annotation returns [$value]
//	:	ap=annotationPropertyIRI at=annotationTarget 
//	;
//
//annotationTarget returns [$value]
//	:	NODE_ID 
//	|	iri 
//	|	literal 
//	;
//annotations returns [$value]
//	: (ANNOTATIONS_LABEL a=annotationAnnotatedList )?
//	;
//
descriptionAnnotatedList returns [$value]
   :	//annotations? 
d1=description 
(COMMA 
//annotations? 
d2=description )*
   ;

////description2List returns [$value]
//// 	:	d=description COMMA dl=descriptionList 
//// 	;
//// 
//descriptionList returns [$value]
// 	:	d1=description  (COMMA d2=description )*
// 	;
// 
classFrame returns [$value]
//@init
  :	CLASS_LABEL 
c=classIRI
  (	//ANNOTATIONS_LABEL annotationAnnotatedList
    //|	
SUBCLASS_OF_LABEL s=descriptionAnnotatedList
//// 		|	EQUIVALENT_TO_LABEL e=descriptionAnnotatedList 
//// 		|	DISJOINT_WITH_LABEL d=descriptionAnnotatedList
//// 		|	DISJOINT_UNION_OF_LABEL annotations description2List
  )*
//// 	//TODO owl2 primer error?
//// 	(	HAS_KEY_LABEL annotations?
//// 			(objectPropertyExpression | dataPropertyExpression)+)?
EOF
  ;
//// 
//// objectPropertyFrame
//// 	:	OBJECT_PROPERTY_LABEL objectPropertyIRI
//// 	(	ANNOTATIONS_LABEL annotationAnnotatedList
//// 		|	RANGE_LABEL descriptionAnnotatedList
//// 		|	CHARACTERISTICS_LABEL objectPropertyCharacteristicAnnotatedList
//// 		|	SUB_PROPERTY_OF_LABEL objectPropertyExpressionAnnotatedList
//// 		|	EQUIVALENT_TO_LABEL objectPropertyExpressionAnnotatedList
//// 		|	DISJOINT_WITH_LABEL objectPropertyExpressionAnnotatedList
//// 		|	INVERSE_OF_LABEL objectPropertyExpressionAnnotatedList
//// 		|	SUB_PROPERTY_CHAIN_LABEL annotations objectPropertyExpression (O_LABEL objectPropertyExpression)+
//// 		)*
//// 	;
//
//objectPropertyCharacteristicAnnotatedList
//	:	annotations? OBJECT_PROPERTY_CHARACTERISTIC (COMMA annotations? OBJECT_PROPERTY_CHARACTERISTIC)*
// 	;
//
//objectPropertyExpressionAnnotatedList
// 	:	annotations? objectPropertyExpression (COMMA annotations? objectPropertyExpression)*
// 	;
// 
//// dataPropertyFrame
////     : DATA_PROPERTY_LABEL  dataPropertyIRI
////     (	ANNOTATIONS_LABEL annotationAnnotatedList
////     |	DOMAIN_LABEL  descriptionAnnotatedList
////     |	RANGE_LABEL  dataRangeAnnotatedList
////     |	CHARACTERISTICS_LABEL  annotations FUNCTIONAL_LABEL
////     |	SUB_PROPERTY_OF_LABEL  dataPropertyExpressionAnnotatedList
////     |	EQUIVALENT_TO_LABEL  dataPropertyExpressionAnnotatedList
////     |	DISJOINT_WITH_LABEL  dataPropertyExpressionAnnotatedList
////     )*
////     ;
//// 
//// dataRangeAnnotatedList
////  	:	annotations? dataRange (COMMA dataRangeAnnotatedList)*
////  	;
// 
//dataPropertyExpressionAnnotatedList
//  	:	annotations? dataPropertyExpression (COMMA annotations? dataPropertyExpression)*
//  	;
// 
//annotationPropertyFrame
// 	:	ANNOTATION_PROPERTY_LABEL annotationPropertyIRI
// 	(	ANNOTATIONS_LABEL  annotationAnnotatedList )*
// 	|	DOMAIN_LABEL  iriAnnotatedList
// 	|	RANGE_LABEL  iriAnnotatedList
// 	|	SUB_PROPERTY_OF_LABEL annotationPropertyIRIAnnotatedList
// 	;
// 	
//iriAnnotatedList
// 	:	annotations? iri (COMMA annotations? iri)*
// 	;
// 
//annotationPropertyIRI returns [$value]
//	:	iri 
// 	;
// 
//annotationPropertyIRIAnnotatedList
// 	:	annotations? annotationPropertyIRI (COMMA annotationPropertyIRIAnnotatedList)*
// 	;
// 
//// individualFrame returns [$value]
//// 	:	INDIVIDUAL_LABEL  i=individual
//// 	(	ANNOTATIONS_LABEL  a=annotationAnnotatedList 
//// 		|	TYPES_LABEL  d=descriptionAnnotatedList 
//// 		|	FACTS_LABEL  f=factAnnotatedList 
//// 		|	SAME_AS_LABEL  ial=individualAnnotatedList 
//// 		|	DIFFERENET_FROM_LABEL ial1=individualAnnotatedList 
//// 	)*
//// 	;
//
//factAnnotatedList returns [$value]
//	:	annotations? fact (COMMA annotations? fact)*
// 	;
//
//individualAnnotatedList returns [$value]
// 	:	annotations? individual (COMMA annotations? individual)*
// 	;
// 
//fact	:	NOT_LABEL? (objectPropertyFact | dataPropertyFact);
//
//objectPropertyFact
// 	:	objectPropertyIRI individual
// 	;
// 
//dataPropertyFact
// 	:	dataPropertyIRI literal
// 	;
// 
//datatypeFrame
// 	:	DATATYPE_LABEL  dataType
// 		(ANNOTATIONS_LABEL  annotationAnnotatedList)*
// 		(EQUIVALENT_TO_LABEL  annotations dataRange)?
// 		(ANNOTATIONS_LABEL  annotationAnnotatedList)*
// 	;
// 
//// misc returns [$value]
//// 	:	EQUIVALENT_CLASSES_LABEL  annotations description2List
//// 	|	DISJOINT_CLASSES_LABEL  annotations description2List 
//// 	|	EQUIVALENT_PROPERTIES_LABEL  annotations (objectProperty2List | dataProperty2List)
//// 	|	DISJOINT_PROPERTIES_LABEL  annotations (objectProperty2List | dataProperty2List)
//// 	|	SAME_INDIVIDUAL_LABEL  annotations individual2List
//// 	|	DIFFERENT_INDIVIDUALS_LABEL  annotations individual2List
//// 	;
//	
//individual2List
//	:	individual COMMA individualList
//	;
//
//dataProperty2List
// 	:	dataProperty COMMA dataPropertyList
// 	;
// 	
//dataPropertyList
//	:	dataProperty (COMMA dataProperty)*
// 	;
// 
//objectProperty2List
// 	:	objectProperty COMMA objectPropertyList
// 	;
// 
//objectPropertyList
// 	:	objectProperty (COMMA objectProperty)*
// 	;
// 
//// frame
//// 	: datatypeFrame
//// 	| classFrame
//// 	| objectPropertyFrame
//// 	| dataPropertyFrame
//// 	| annotationPropertyFrame
//// 	| individualFrame
//// 	| misc
//// 	;
//
//entity
// 	: DATATYPE_LABEL OPEN_BRACE dataType CLOSE_BRACE
// 	| CLASS_LABEL OPEN_BRACE classIRI CLOSE_BRACE
// 	| OBJECT_PROPERTY_LABEL OPEN_BRACE objectPropertyIRI CLOSE_BRACE
// 	| DATA_PROPERTY_LABEL OPEN_BRACE datatypePropertyIRI CLOSE_BRACE
// 	| ANNOTATION_PROPERTY_LABEL OPEN_BRACE annotationPropertyIRI CLOSE_BRACE
// 	| NAMED_INDIVIDUAL_LABEL OPEN_BRACE individualIRI CLOSE_BRACE
// 	;
// 
//// ontology
//// 	: ONTOLOGY_LABEL (ontologyIri (versionIri)?)? imports* annotations* frame*
//// 	;
//
//ontologyIri
//	: iri
//	;
//
//versionIri
//	:	iri
//	;
//
//imports	:	IMPORT_LABEL iri;
//
//
//
//
ITFUCKINDOESNTWORK : 'ggggggggr!!!';
