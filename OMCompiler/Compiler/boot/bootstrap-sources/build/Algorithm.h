#ifndef Algorithm__H
#define Algorithm__H
#include "meta/meta_modelica.h"
#include "util/modelica.h"
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#ifdef __cplusplus
extern "C" {
#endif
extern struct record_description DAE_Else_ELSE__desc;
extern struct record_description DAE_Else_ELSEIF__desc;
extern struct record_description DAE_Else_NOELSE__desc;
extern struct record_description DAE_Exp_TSUB__desc;
extern struct record_description DAE_Statement_STMT__ASSERT__desc;
extern struct record_description DAE_Statement_STMT__ASSIGN__desc;
extern struct record_description DAE_Statement_STMT__ASSIGN__ARR__desc;
extern struct record_description DAE_Statement_STMT__FOR__desc;
extern struct record_description DAE_Statement_STMT__IF__desc;
extern struct record_description DAE_Statement_STMT__NORETCALL__desc;
extern struct record_description DAE_Statement_STMT__PARFOR__desc;
extern struct record_description DAE_Statement_STMT__REINIT__desc;
extern struct record_description DAE_Statement_STMT__TERMINATE__desc;
extern struct record_description DAE_Statement_STMT__TUPLE__ASSIGN__desc;
extern struct record_description DAE_Statement_STMT__WHEN__desc;
extern struct record_description DAE_Statement_STMT__WHILE__desc;
extern struct record_description DAE_Type_T__BOOL__desc;
extern struct record_description DAE_Type_T__REAL__desc;
extern struct record_description ErrorTypes_Message_MESSAGE__desc;
extern struct record_description ErrorTypes_MessageType_TRANSLATION__desc;
extern struct record_description ErrorTypes_Severity_ERROR__desc;
extern struct record_description ErrorTypes_Severity_WARNING__desc;
extern struct record_description Flags_DebugFlag_DEBUG__FLAG__desc;
extern struct record_description Gettext_TranslatableContent_gettext__desc;
DLLExport
modelica_boolean omc_Algorithm_isNotDummyStatement(threadData_t *threadData, modelica_metatype _stmt);
DLLExport
modelica_metatype boxptr_Algorithm_isNotDummyStatement(threadData_t *threadData, modelica_metatype _stmt);
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_isNotDummyStatement,2,0) {(void*) boxptr_Algorithm_isNotDummyStatement,0}};
#define boxvar_Algorithm_isNotDummyStatement MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_isNotDummyStatement)
DLLExport
modelica_metatype omc_Algorithm_getAssertCond(threadData_t *threadData, modelica_metatype _stmt);
#define boxptr_Algorithm_getAssertCond omc_Algorithm_getAssertCond
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_getAssertCond,2,0) {(void*) boxptr_Algorithm_getAssertCond,0}};
#define boxvar_Algorithm_getAssertCond MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_getAssertCond)
DLLExport
modelica_metatype omc_Algorithm_getStatementSource(threadData_t *threadData, modelica_metatype _stmt);
#define boxptr_Algorithm_getStatementSource omc_Algorithm_getStatementSource
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_getStatementSource,2,0) {(void*) boxptr_Algorithm_getStatementSource,0}};
#define boxvar_Algorithm_getStatementSource MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_getStatementSource)
DLLExport
modelica_metatype omc_Algorithm_getAllExpsStmts(threadData_t *threadData, modelica_metatype _stmts);
#define boxptr_Algorithm_getAllExpsStmts omc_Algorithm_getAllExpsStmts
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_getAllExpsStmts,2,0) {(void*) boxptr_Algorithm_getAllExpsStmts,0}};
#define boxvar_Algorithm_getAllExpsStmts MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_getAllExpsStmts)
DLLExport
modelica_metatype omc_Algorithm_getAllExps(threadData_t *threadData, modelica_metatype _inAlgorithm);
#define boxptr_Algorithm_getAllExps omc_Algorithm_getAllExps
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_getAllExps,2,0) {(void*) boxptr_Algorithm_getAllExps,0}};
#define boxvar_Algorithm_getAllExps MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_getAllExps)
DLLExport
modelica_metatype omc_Algorithm_getCrefFromAlg(threadData_t *threadData, modelica_metatype _alg);
#define boxptr_Algorithm_getCrefFromAlg omc_Algorithm_getCrefFromAlg
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_getCrefFromAlg,2,0) {(void*) boxptr_Algorithm_getCrefFromAlg,0}};
#define boxvar_Algorithm_getCrefFromAlg MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_getCrefFromAlg)
DLLExport
modelica_metatype omc_Algorithm_makeTerminate(threadData_t *threadData, modelica_metatype _msg, modelica_metatype _props, modelica_metatype _source);
#define boxptr_Algorithm_makeTerminate omc_Algorithm_makeTerminate
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeTerminate,2,0) {(void*) boxptr_Algorithm_makeTerminate,0}};
#define boxvar_Algorithm_makeTerminate MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeTerminate)
DLLExport
modelica_metatype omc_Algorithm_makeAssert(threadData_t *threadData, modelica_metatype _cond, modelica_metatype _msg, modelica_metatype _level, modelica_metatype _inProperties3, modelica_metatype _inProperties4, modelica_metatype _inProperties5, modelica_metatype _source);
#define boxptr_Algorithm_makeAssert omc_Algorithm_makeAssert
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeAssert,2,0) {(void*) boxptr_Algorithm_makeAssert,0}};
#define boxvar_Algorithm_makeAssert MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeAssert)
DLLExport
modelica_metatype omc_Algorithm_makeReinit(threadData_t *threadData, modelica_metatype _inExp1, modelica_metatype _inExp2, modelica_metatype _inProperties3, modelica_metatype _inProperties4, modelica_metatype _source);
#define boxptr_Algorithm_makeReinit omc_Algorithm_makeReinit
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeReinit,2,0) {(void*) boxptr_Algorithm_makeReinit,0}};
#define boxvar_Algorithm_makeReinit MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeReinit)
DLLExport
modelica_metatype omc_Algorithm_makeWhenA(threadData_t *threadData, modelica_metatype _inExp, modelica_metatype _inProperties, modelica_metatype _inStatementLst, modelica_metatype _elseWhenStmt, modelica_metatype _source);
#define boxptr_Algorithm_makeWhenA omc_Algorithm_makeWhenA
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeWhenA,2,0) {(void*) boxptr_Algorithm_makeWhenA,0}};
#define boxvar_Algorithm_makeWhenA MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeWhenA)
DLLExport
modelica_metatype omc_Algorithm_makeWhile(threadData_t *threadData, modelica_metatype _inExp, modelica_metatype _inProperties, modelica_metatype _inStatementLst, modelica_metatype _source);
#define boxptr_Algorithm_makeWhile omc_Algorithm_makeWhile
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeWhile,2,0) {(void*) boxptr_Algorithm_makeWhile,0}};
#define boxvar_Algorithm_makeWhile MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeWhile)
DLLExport
modelica_metatype omc_Algorithm_makeParFor(threadData_t *threadData, modelica_string _inIdent, modelica_metatype _inExp, modelica_metatype _inProperties, modelica_metatype _inStatementLst, modelica_metatype _inLoopPrlVars, modelica_metatype _source);
#define boxptr_Algorithm_makeParFor omc_Algorithm_makeParFor
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeParFor,2,0) {(void*) boxptr_Algorithm_makeParFor,0}};
#define boxvar_Algorithm_makeParFor MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeParFor)
DLLExport
modelica_metatype omc_Algorithm_makeFor(threadData_t *threadData, modelica_string _inIdent, modelica_metatype _inExp, modelica_metatype _inProperties, modelica_metatype _inStatementLst, modelica_metatype _source);
#define boxptr_Algorithm_makeFor omc_Algorithm_makeFor
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeFor,2,0) {(void*) boxptr_Algorithm_makeFor,0}};
#define boxvar_Algorithm_makeFor MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeFor)
#define boxptr_Algorithm_makeElse omc_Algorithm_makeElse
DLLExport
modelica_metatype omc_Algorithm_optimizeElseIf(threadData_t *threadData, modelica_metatype _cond, modelica_metatype _stmts, modelica_metatype _els);
#define boxptr_Algorithm_optimizeElseIf omc_Algorithm_optimizeElseIf
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_optimizeElseIf,2,0) {(void*) boxptr_Algorithm_optimizeElseIf,0}};
#define boxvar_Algorithm_optimizeElseIf MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_optimizeElseIf)
DLLExport
modelica_metatype omc_Algorithm_optimizeIf(threadData_t *threadData, modelica_metatype _icond, modelica_metatype _istmts, modelica_metatype _iels, modelica_metatype _isource, modelica_boolean *out_changed);
DLLExport
modelica_metatype boxptr_Algorithm_optimizeIf(threadData_t *threadData, modelica_metatype _icond, modelica_metatype _istmts, modelica_metatype _iels, modelica_metatype _isource, modelica_metatype *out_changed);
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_optimizeIf,2,0) {(void*) boxptr_Algorithm_optimizeIf,0}};
#define boxvar_Algorithm_optimizeIf MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_optimizeIf)
#define boxptr_Algorithm_makeElseFromBranches omc_Algorithm_makeElseFromBranches
DLLExport
modelica_metatype omc_Algorithm_makeIfFromBranches(threadData_t *threadData, modelica_metatype _branches, modelica_metatype _source);
#define boxptr_Algorithm_makeIfFromBranches omc_Algorithm_makeIfFromBranches
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeIfFromBranches,2,0) {(void*) boxptr_Algorithm_makeIfFromBranches,0}};
#define boxvar_Algorithm_makeIfFromBranches MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeIfFromBranches)
DLLExport
modelica_metatype omc_Algorithm_makeIf(threadData_t *threadData, modelica_metatype _inExp, modelica_metatype _inProperties, modelica_metatype _inTrueBranch, modelica_metatype _inElseIfBranches, modelica_metatype _inElseBranch, modelica_metatype _source);
#define boxptr_Algorithm_makeIf omc_Algorithm_makeIf
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeIf,2,0) {(void*) boxptr_Algorithm_makeIf,0}};
#define boxvar_Algorithm_makeIf MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeIf)
#define boxptr_Algorithm_getPropExpType omc_Algorithm_getPropExpType
DLLExport
modelica_metatype omc_Algorithm_makeTupleAssignment(threadData_t *threadData, modelica_metatype _inExpExpLst, modelica_metatype _inTypesPropertiesLst, modelica_metatype _inExp, modelica_metatype _inProperties, modelica_metatype _initial_, modelica_metatype _source);
#define boxptr_Algorithm_makeTupleAssignment omc_Algorithm_makeTupleAssignment
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeTupleAssignment,2,0) {(void*) boxptr_Algorithm_makeTupleAssignment,0}};
#define boxvar_Algorithm_makeTupleAssignment MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeTupleAssignment)
DLLExport
void omc_Algorithm_checkLHSWritable(threadData_t *threadData, modelica_metatype _lhs, modelica_metatype _props, modelica_metatype _rhs, modelica_metatype _source);
#define boxptr_Algorithm_checkLHSWritable omc_Algorithm_checkLHSWritable
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_checkLHSWritable,2,0) {(void*) boxptr_Algorithm_checkLHSWritable,0}};
#define boxvar_Algorithm_checkLHSWritable MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_checkLHSWritable)
DLLExport
modelica_metatype omc_Algorithm_makeAssignmentsList(threadData_t *threadData, modelica_metatype _lhsExps, modelica_metatype _lhsProps, modelica_metatype _rhsExps, modelica_metatype _rhsProps, modelica_metatype _attributes, modelica_metatype _initial_, modelica_metatype _source);
#define boxptr_Algorithm_makeAssignmentsList omc_Algorithm_makeAssignmentsList
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeAssignmentsList,2,0) {(void*) boxptr_Algorithm_makeAssignmentsList,0}};
#define boxvar_Algorithm_makeAssignmentsList MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeAssignmentsList)
DLLExport
modelica_metatype omc_Algorithm_makeSimpleAssignment(threadData_t *threadData, modelica_metatype _inTpl, modelica_metatype _source);
#define boxptr_Algorithm_makeSimpleAssignment omc_Algorithm_makeSimpleAssignment
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeSimpleAssignment,2,0) {(void*) boxptr_Algorithm_makeSimpleAssignment,0}};
#define boxvar_Algorithm_makeSimpleAssignment MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeSimpleAssignment)
#define boxptr_Algorithm_makeAssignment2 omc_Algorithm_makeAssignment2
DLLExport
modelica_metatype omc_Algorithm_makeAssignment(threadData_t *threadData, modelica_metatype _inExp1, modelica_metatype _inProperties2, modelica_metatype _inExp3, modelica_metatype _inProperties4, modelica_metatype _inAttributes, modelica_metatype _initial_, modelica_metatype _source);
#define boxptr_Algorithm_makeAssignment omc_Algorithm_makeAssignment
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeAssignment,2,0) {(void*) boxptr_Algorithm_makeAssignment,0}};
#define boxvar_Algorithm_makeAssignment MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeAssignment)
DLLExport
modelica_metatype omc_Algorithm_makeTupleAssignmentNoTypeCheck(threadData_t *threadData, modelica_metatype _ty, modelica_metatype _lhs, modelica_metatype _rhs, modelica_metatype _source);
#define boxptr_Algorithm_makeTupleAssignmentNoTypeCheck omc_Algorithm_makeTupleAssignmentNoTypeCheck
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeTupleAssignmentNoTypeCheck,2,0) {(void*) boxptr_Algorithm_makeTupleAssignmentNoTypeCheck,0}};
#define boxvar_Algorithm_makeTupleAssignmentNoTypeCheck MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeTupleAssignmentNoTypeCheck)
DLLExport
modelica_metatype omc_Algorithm_makeArrayAssignmentNoTypeCheck(threadData_t *threadData, modelica_metatype _ty, modelica_metatype _lhs, modelica_metatype _rhs, modelica_metatype _source);
#define boxptr_Algorithm_makeArrayAssignmentNoTypeCheck omc_Algorithm_makeArrayAssignmentNoTypeCheck
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeArrayAssignmentNoTypeCheck,2,0) {(void*) boxptr_Algorithm_makeArrayAssignmentNoTypeCheck,0}};
#define boxvar_Algorithm_makeArrayAssignmentNoTypeCheck MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeArrayAssignmentNoTypeCheck)
DLLExport
modelica_metatype omc_Algorithm_makeAssignmentNoTypeCheck(threadData_t *threadData, modelica_metatype _ty, modelica_metatype _lhs, modelica_metatype _rhs, modelica_metatype _source);
#define boxptr_Algorithm_makeAssignmentNoTypeCheck omc_Algorithm_makeAssignmentNoTypeCheck
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_makeAssignmentNoTypeCheck,2,0) {(void*) boxptr_Algorithm_makeAssignmentNoTypeCheck,0}};
#define boxvar_Algorithm_makeAssignmentNoTypeCheck MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_makeAssignmentNoTypeCheck)
DLLExport
modelica_boolean omc_Algorithm_isNotAssertStatement(threadData_t *threadData, modelica_metatype _stmt);
DLLExport
modelica_metatype boxptr_Algorithm_isNotAssertStatement(threadData_t *threadData, modelica_metatype _stmt);
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_isNotAssertStatement,2,0) {(void*) boxptr_Algorithm_isNotAssertStatement,0}};
#define boxvar_Algorithm_isNotAssertStatement MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_isNotAssertStatement)
DLLExport
modelica_boolean omc_Algorithm_isReinitStatement(threadData_t *threadData, modelica_metatype _stmt);
DLLExport
modelica_metatype boxptr_Algorithm_isReinitStatement(threadData_t *threadData, modelica_metatype _stmt);
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_isReinitStatement,2,0) {(void*) boxptr_Algorithm_isReinitStatement,0}};
#define boxvar_Algorithm_isReinitStatement MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_isReinitStatement)
DLLExport
modelica_boolean omc_Algorithm_algorithmEmpty(threadData_t *threadData, modelica_metatype _alg);
DLLExport
modelica_metatype boxptr_Algorithm_algorithmEmpty(threadData_t *threadData, modelica_metatype _alg);
static const MMC_DEFSTRUCTLIT(boxvar_lit_Algorithm_algorithmEmpty,2,0) {(void*) boxptr_Algorithm_algorithmEmpty,0}};
#define boxvar_Algorithm_algorithmEmpty MMC_REFSTRUCTLIT(boxvar_lit_Algorithm_algorithmEmpty)
#ifdef __cplusplus
}
#endif
#endif
