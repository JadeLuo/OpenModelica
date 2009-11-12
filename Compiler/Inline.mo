/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-2008, Link�pings University,
 * Department of Computer and Information Science,
 * SE-58183 Link�ping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF THIS OSMC PUBLIC
 * LICENSE (OSMC-PL). ANY USE, REPRODUCTION OR DISTRIBUTION OF
 * THIS PROGRAM CONSTITUTES RECIPIENT'S ACCEPTANCE OF THE OSMC
 * PUBLIC LICENSE.
 *
 * The OpenModelica software and the Open Source Modelica
 * Consortium (OSMC) Public License (OSMC-PL) are obtained
 * from Link�pings University, either from the above address,
 * from the URL: http://www.ida.liu.se/projects/OpenModelica
 * and in the OpenModelica distribution.
 *
 * This program is distributed  WITHOUT ANY WARRANTY; without
 * even the implied warranty of  MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE, EXCEPT AS EXPRESSLY SET FORTH
 * IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE CONDITIONS
 * OF OSMC-PL.
 *
 * See the full OSMC Public License conditions for more details.
 *
 */

// stefan
package Inline
" file:	       Inline.mo
  package:     Inline
  description: inline functions
  
  RCS: $Id: PartFn.mo 4306 2009-10-06 06:32:29Z sjoelund.se $
  
  This module contains data structures and functions for inline functions.
  
  The entry point is the inlineCalls function, or inlineCallsInFunctions
  "

public import DAE;
public import DAELow;
public import Absyn;
public import Exp;
public import SCode;
public import Util;
public import Algorithm;
public import Types;
public import Values;

type Ident = String;

protected import Debug;
protected import DAEUtil;

public function inlineCalls
"function: inlineCalls
	searches for calls where the inline flag is true, and inlines them"
	input list<DAE.Element> inElementList "functions";
	input DAELow.DAELow inDAELow;
  output DAELow.DAELow outDAELow;
algorithm
  outDAELow := matchcontinue(inElementList,inDAELow)
    local
      list<DAE.Element> fns;
      DAELow.Variables orderedVars;
      DAELow.Variables knownVars;
      DAELow.Variables externalObjects;
      DAELow.EquationArray orderedEqs;
      DAELow.EquationArray removedEqs;
      DAELow.EquationArray initialEqs;
      DAELow.MultiDimEquation[:] arrayEqs;
      list<DAELow.MultiDimEquation> mdelst;
      Algorithm.Algorithm[:] algorithms;
      list<Algorithm.Algorithm> alglst;
      DAELow.EventInfo eventInfo;
      DAELow.ExternalObjectClasses extObjClasses;
    case(fns,DAELow.DAELOW(orderedVars,knownVars,externalObjects,orderedEqs,removedEqs,initialEqs,arrayEqs,algorithms,eventInfo,extObjClasses))
      equation
        orderedVars = inlineVariables(orderedVars,fns);
        knownVars = inlineVariables(knownVars,fns);
        externalObjects = inlineVariables(externalObjects,fns);
        orderedEqs = inlineEquationArray(orderedEqs,fns);
        removedEqs = inlineEquationArray(removedEqs,fns);
        initialEqs = inlineEquationArray(initialEqs,fns);
        mdelst = Util.listMap1(arrayList(arrayEqs),inlineMultiDimEqs,fns);
        arrayEqs = listArray(mdelst);
        alglst = Util.listMap1(arrayList(algorithms),inlineAlgorithm,fns);
        algorithms = listArray(alglst);
        eventInfo = inlineEventInfo(eventInfo,fns);
        extObjClasses = inlineExtObjClasses(extObjClasses,fns);
      then
        DAELow.DAELOW(orderedVars,knownVars,externalObjects,orderedEqs,removedEqs,initialEqs,arrayEqs,algorithms,eventInfo,extObjClasses);
    case(_,_)
      equation
        Debug.fprintln("failtrace","Inline.inlineCalls failed");
      then
        fail();
  end matchcontinue;
end inlineCalls;

protected function inlineEquationArray
"function: inlineEquationArray
	inlines function calls in an equation array"
	input DAELow.EquationArray inEquationArray;
	input list<DAE.Element> inElementList;
	output DAELow.EquationArray outEquationArray;
algorithm
  outEquationArray := matchcontinue(inEquationArray,inElementList)
    local
      list<DAE.Element> fns;
      Integer i1,i2;
      Option<DAELow.Equation>[:] eqarr,eqarr_1;
      list<Option<DAELow.Equation>> eqlst,eqlst_1;
    case(DAELow.EQUATION_ARRAY(i1,i2,eqarr),fns)
      equation
        eqlst = arrayList(eqarr);
        eqlst_1 = Util.listMap1(eqlst,inlineEqOpt,fns);
        eqarr_1 = listArray(eqlst_1);
      then
        DAELow.EQUATION_ARRAY(i1,i2,eqarr_1);
  end matchcontinue;
end inlineEquationArray;

protected function inlineEqOpt
"function: inlineEqOpt
	inlines function calls in equations"
	input Option<DAELow.Equation> inEquationOption;
	input list<DAE.Element> inElementList;
	output Option<DAELow.Equation> outEquationOption;
algorithm
  outEquationOption := matchcontinue(inEquationOption,inElementList)
    local
      list<DAE.Element> fns;
      Exp.Exp e,e_1,e1,e1_1,e2,e2_1;
      Integer i;
      list<Exp.Exp> explst,explst_1,explst1,explst1_1,explst2,explst2_1;
      Exp.ComponentRef cref;
      DAELow.WhenEquation weq,weq_1;
    case(NONE,_) then NONE;
    case(SOME(DAELow.EQUATION(e1,e2)),fns)
      equation
        e1_1 = inlineExp(e1,fns);
        e2_1 = inlineExp(e2,fns);
      then
        SOME(DAELow.EQUATION(e1_1,e2_1));
    case(SOME(DAELow.ARRAY_EQUATION(i,explst)),fns)
      equation
        explst_1 = Util.listMap1(explst,inlineExp,fns);
      then
        SOME(DAELow.ARRAY_EQUATION(i,explst_1));
    case(SOME(DAELow.SOLVED_EQUATION(cref,e)),fns)
      equation
        e_1 = inlineExp(e,fns);
      then
        SOME(DAELow.SOLVED_EQUATION(cref,e_1));
    case(SOME(DAELow.RESIDUAL_EQUATION(e)),fns)
      equation
        e_1 = inlineExp(e,fns);
      then
        SOME(DAELow.RESIDUAL_EQUATION(e_1));
    case(SOME(DAELow.ALGORITHM(i,explst1,explst2)),fns)
      equation
        explst1_1 = Util.listMap1(explst1,inlineExp,fns);
        explst2_1 = Util.listMap1(explst2,inlineExp,fns);
      then
        SOME(DAELow.ALGORITHM(i,explst1_1,explst2_1));
    case(SOME(DAELow.WHEN_EQUATION(weq)),fns)
      equation
        weq_1 = inlineWhenEq(weq,fns);
      then
        SOME(DAELow.WHEN_EQUATION(weq_1));
  end matchcontinue;
end inlineEqOpt;

protected function inlineWhenEq
"function: inlineWhenEq
	inlines function calls in when equations"
	input DAELow.WhenEquation inWhenEquation;
	input list<DAE.Element> inElementList;
	output DAELow.WhenEquation outWhenEquation;
algorithm
  outWhenEquation := matchcontinue(inWhenEquation,inElementList)
    local
      list<DAE.Element> fns;
      Integer i;
      Exp.ComponentRef cref;
      Exp.Exp e,e_1;
      DAELow.WhenEquation weq,weq_1;
    case(DAELow.WHEN_EQ(i,cref,e,NONE),fns)
      equation
        e_1 = inlineExp(e,fns);
      then
        DAELow.WHEN_EQ(i,cref,e_1,NONE);
    case(DAELow.WHEN_EQ(i,cref,e,SOME(weq)),fns)
      equation
        e_1 = inlineExp(e,fns);
        weq_1 = inlineWhenEq(weq,fns);
      then
        DAELow.WHEN_EQ(i,cref,e_1,SOME(weq_1));
  end matchcontinue;
end inlineWhenEq;

protected function inlineVariables
"function: inlineVariables
	inlines function calls in variables"
	input DAELow.Variables inVariables;
	input list<DAE.Element> inElementList;
	output DAELow.Variables outVariables;
algorithm
  outVariables := matchcontinue(inVariables,inElementList)
    local
      list<DAE.Element> fns;
      list<DAELow.CrefIndex>[:] crefind;
      list<DAELow.StringIndex>[:] strind;
      Integer i1,i2,i3,i4;
      Option<DAELow.Var>[:] vararr,vararr_1;
      list<Option<DAELow.Var>> varlst,varlst_1;
    case(DAELow.VARIABLES(crefind,strind,DAELow.VARIABLE_ARRAY(i3,i4,vararr),i1,i2),fns)
      equation
        varlst = arrayList(vararr);
        varlst_1 = Util.listMap1(varlst,inlineVarOpt,fns);
        vararr_1 = listArray(varlst_1);
      then
        DAELow.VARIABLES(crefind,strind,DAELow.VARIABLE_ARRAY(i3,i4,vararr_1),i1,i2);
  end matchcontinue;
end inlineVariables;

protected function inlineVarOpt
"functio: inlineVarOpt
	inlines calls in a variable option"
	input Option<DAELow.Var> inVarOption;
	input list<DAE.Element> inElementList;
	output Option<DAELow.Var> outVarOption;
algorithm
  outVarOption := matchcontinue(inVarOption,inElementList)
    local
      list<DAE.Element> fns;
      Exp.ComponentRef varName;
      DAELow.VarKind varKind;
      DAE.VarDirection varDirection;
      DAELow.Type varType;
      Exp.Exp e,e_1;
      Option<Values.Value> bindValue;
      DAE.InstDims arrayDim;
      Integer index;
      Exp.ComponentRef origVarName;
      list<Absyn.Path> className;
      Option<DAE.VariableAttributes> values;
      Option<SCode.Comment> comment;
      DAE.Flow flowPrefix;
      DAE.Stream streamPrefix;
      Option<DAELow.Var> var;
    case(NONE,_) then NONE;
    case(SOME(DAELow.VAR(varName,varKind,varDirection,varType,SOME(e),bindValue,arrayDim,index,origVarName,className,values,comment,flowPrefix,streamPrefix)),fns)
      equation
        e_1 = inlineExp(e,fns);
      then
        SOME(DAELow.VAR(varName,varKind,varDirection,varType,SOME(e_1),bindValue,arrayDim,index,origVarName,className,values,comment,flowPrefix,streamPrefix));
    case(var,_) then var;
  end matchcontinue;
end inlineVarOpt;

protected function inlineMultiDimEqs
"function: inlineMultiDimEqs
	inlines function calls in multi dim equations"
	input DAELow.MultiDimEquation inMultiDimEquation;
	input list<DAE.Element> inElementList;
	output DAELow.MultiDimEquation outMultiDimEquation;
algorithm
  outMultiDimEquation := matchcontinue(inMultiDimEquation,inElementList)
    local
      list<DAE.Element> fns;
      list<Integer> ilst;
      Exp.Exp e1,e1_1,e2,e2_1;
    case(DAELow.MULTIDIM_EQUATION(ilst,e1,e2),fns)
      equation
        e1_1 = inlineExp(e1,fns);
        e2_1 = inlineExp(e2,fns);
      then
        DAELow.MULTIDIM_EQUATION(ilst,e1_1,e2_1);
  end matchcontinue;
end inlineMultiDimEqs;

protected function inlineEventInfo
"function: inlineEventInfo
	inlines function calls in event info"
	input DAELow.EventInfo inEventInfo;
	input list<DAE.Element> inElementList;
	output DAELow.EventInfo outEventInfo;
algorithm
  outEventInfo := matchcontinue(inEventInfo,inElementList)
    local
      list<DAE.Element> fns;
      list<DAELow.WhenClause> wclst,wclst_1;
      list<DAELow.ZeroCrossing> zclst,zclst_1;
    case(DAELow.EVENT_INFO(wclst,zclst),fns)
      equation
        wclst_1 = Util.listMap1(wclst,inlineWhenClause,fns);
        zclst_1 = Util.listMap1(zclst,inlineZeroCrossing,fns);
      then
        DAELow.EVENT_INFO(wclst_1,zclst_1);
  end matchcontinue;
end inlineEventInfo;

protected function inlineZeroCrossing
"function: inlineZeroCrossing
	inlines function calls in a zero crossing"
	input DAELow.ZeroCrossing inZeroCrossing;
	input list<DAE.Element> inElementList;
	output DAELow.ZeroCrossing outZeroCrossing;
algorithm
  outZeroCrossing := matchcontinue(inZeroCrossing,inElementList)
    local
      list<DAE.Element> fns;
      Exp.Exp e,e_1;
      list<Integer> ilst1,ilst2;
    case(DAELow.ZERO_CROSSING(e,ilst1,ilst2),fns)
      equation
        e_1 = inlineExp(e,fns);
      then
        DAELow.ZERO_CROSSING(e_1,ilst1,ilst2);
  end matchcontinue;
end inlineZeroCrossing;

protected function inlineWhenClause
"function: inlineWhenClause
	inlines function calls in a when clause"
	input DAELow.WhenClause inWhenClause;
	input list<DAE.Element> inElementList;
	output DAELow.WhenClause outWhenClause;
algorithm
  outWhenClause := matchcontinue(inWhenClause,inElementList)
    local
      list<DAE.Element> fns;
      Exp.Exp e,e_1;
      list<DAELow.ReinitStatement> rslst,rslst_1;
      Option<Integer> io;
    case(DAELow.WHEN_CLAUSE(e,rslst,io),fns)
      equation
        e_1 = inlineExp(e,fns);
        rslst_1 = Util.listMap1(rslst,inlineReinitStmt,fns);
      then
        DAELow.WHEN_CLAUSE(e_1,rslst_1,io);
  end matchcontinue;
end inlineWhenClause;

protected function inlineReinitStmt
"function: inlineReinitStmt
	inlines function calls in a reinit statement"
	input DAELow.ReinitStatement inReinitStatement;
	input list<DAE.Element> inElementList;
	output DAELow.ReinitStatement outReinitStatement;
algorithm
  outReinitStatement := matchcontinue(inReinitStatement,inElementList)
    local
      list<DAE.Element> fns;
      Exp.ComponentRef cref;
      Exp.Exp e,e_1;
      DAELow.ReinitStatement rs;
    case(DAELow.REINIT(cref,e),fns)
      equation
        e_1 = inlineExp(e,fns);
      then
        DAELow.REINIT(cref,e_1);
    case(rs,_) then rs;
  end matchcontinue;
end inlineReinitStmt;

protected function inlineExtObjClasses
"function: inlineExtObjClasses
	inlines function calls in external object classes"
	input DAELow.ExternalObjectClasses inExtObjClasses;
	input list<DAE.Element> inElementList;
	output DAELow.ExternalObjectClasses outExtObjClasses;
algorithm
  outExtObjClasses := matchcontinue(inExtObjClasses,inElementList)
    local
      list<DAE.Element> fns;
      DAELow.ExternalObjectClasses cdr,cdr_1;
      DAELow.ExternalObjectClass res;
      Absyn.Path p;
      DAE.Element e1,e1_1,e2,e2_1;
    case({},_) then {};
    case(DAELow.EXTOBJCLASS(p,e1,e2) :: cdr,fns)
      equation
        {e1_1,e2_1} = inlineDAEElements({e1,e2},fns);
        res = DAELow.EXTOBJCLASS(p,e1_1,e2_1);
        cdr_1 = inlineExtObjClasses(cdr,fns);
      then
        res :: cdr_1;
  end matchcontinue;
end inlineExtObjClasses;

public function inlineCallsInFunctions
"function: inlineCallsInFunctions
	inlines function calls within functions"
	input list<DAE.Element> inElementList;
	output list<DAE.Element> outElementList;
algorithm
  outElementList := inlineDAEElements(inElementList,inElementList);
end inlineCallsInFunctions;

protected function inlineDAEElements
"function: inlineDAEElements
	inlines calls in DAEElements"
	input list<DAE.Element> inElementList;
	input list<DAE.Element> inFunctions;
	output list<DAE.Element> outElementList;
algorithm
  outDAElist := matchcontinue(inElementList,inFunctions)
    local
      list<DAE.Element> fns,cdr,cdr_1,elist,elist_1;
      list<list<DAE.Element>> dlist,dlist_1;
      DAE.Element el,el_1,res,el1,el1_1,el2,el2_1;
      Exp.ComponentRef componentRef;
      DAE.VarKind kind;
      DAE.VarDirection direction;
      DAE.VarProtection protection;
      Types.Type ty,t;
      Exp.Exp binding,binding_1,exp,exp_1,exp1,exp1_1,exp2,exp2_1; 
      DAE.InstDims dims;
      DAE.Flow flowPrefix;
      DAE.Stream streamPrefix;
      list<Absyn.Path> pathLst;
      Option<DAE.VariableAttributes> variableAttributesOption;
      Option<SCode.Comment> absynCommentOption;
      Absyn.InnerOuter innerOuter;
      list<Integer> dimension;
      Algorithm.Algorithm alg,alg_1;
      Ident i;
      Absyn.Path p;
      Boolean partialPrefix;
      DAE.ExternalDecl ext;
      list<Exp.Exp> explst,explst_1;
    case({},_) then {};
    case(DAE.VAR(componentRef,kind,direction,protection,ty,SOME(binding),dims,flowPrefix,streamPrefix,pathLst,variableAttributesOption,absynCommentOption,innerOuter) :: cdr,fns)
      equation
        binding_1 = inlineExp(binding,fns);
        res = DAE.VAR(componentRef,kind,direction,protection,ty,SOME(binding_1),dims,flowPrefix,streamPrefix,pathLst,variableAttributesOption,absynCommentOption,innerOuter);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.DEFINE(componentRef,exp) :: cdr,fns)
      equation
        exp_1 = inlineExp(exp,fns);
        res = DAE.DEFINE(componentRef,exp_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.INITIALDEFINE(componentRef,exp) :: cdr,fns)
      equation
        exp_1 = inlineExp(exp,fns);
        res = DAE.INITIALDEFINE(componentRef,exp_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.EQUATION(exp1,exp2) :: cdr,fns)
      equation
        exp1_1 = inlineExp(exp1,fns);
        exp2_1 = inlineExp(exp2,fns);
        res = DAE.EQUATION(exp1_1,exp2_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.ARRAY_EQUATION(dimension,exp1,exp2) :: cdr,fns)
      equation
        exp1_1 = inlineExp(exp1,fns);
        exp2_1 = inlineExp(exp2,fns);
        res = DAE.ARRAY_EQUATION(dimension,exp1_1,exp2_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.COMPLEX_EQUATION(exp1,exp2) :: cdr,fns)
      equation
        exp1_1 = inlineExp(exp1,fns);
        exp2_1 = inlineExp(exp2,fns);
        res = DAE.COMPLEX_EQUATION(exp1_1,exp2_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.INITIAL_COMPLEX_EQUATION(exp1,exp2) :: cdr,fns)
      equation
        exp1_1 = inlineExp(exp1,fns);
        exp2_1 = inlineExp(exp2,fns);
        res = DAE.INITIAL_COMPLEX_EQUATION(exp1_1,exp2_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.WHEN_EQUATION(exp,elist,SOME(el)) :: cdr,fns)
      equation
        exp_1 = inlineExp(exp,fns);
        elist_1 = inlineDAEElements(elist,fns);
        {el_1} = inlineDAEElements({el},fns);
        res = DAE.WHEN_EQUATION(exp_1,elist_1,SOME(el_1));
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.WHEN_EQUATION(exp,elist,NONE) :: cdr,fns)
      equation
        exp_1 = inlineExp(exp,fns);
        elist_1 = inlineDAEElements(elist,fns);
        res = DAE.WHEN_EQUATION(exp_1,elist_1,NONE);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.IF_EQUATION(explst,dlist,elist) :: cdr,fns)
      equation
        explst_1 = Util.listMap1(explst,inlineExp,fns);
        dlist_1 = Util.listMap1(dlist,inlineDAEElements,fns);
        elist_1 = inlineDAEElements(elist,fns);
        res = DAE.IF_EQUATION(explst_1,dlist_1,elist_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.INITIAL_IF_EQUATION(explst,dlist,elist) :: cdr,fns)
      equation
        explst_1 = Util.listMap1(explst,inlineExp,fns);
        dlist_1 = Util.listMap1(dlist,inlineDAEElements,fns);
        elist_1 = inlineDAEElements(elist,fns);
        res = DAE.INITIAL_IF_EQUATION(explst_1,dlist_1,elist_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.INITIALEQUATION(exp1,exp2) :: cdr,fns)
      equation
        exp1_1 = inlineExp(exp1,fns);
        exp2_1 = inlineExp(exp2,fns);
        res = DAE.INITIALEQUATION(exp1_1,exp2_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.ALGORITHM(alg) :: cdr,fns)
      equation
        alg_1 = inlineAlgorithm(alg,fns);
        res = DAE.ALGORITHM(alg_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.INITIALALGORITHM(alg) :: cdr,fns)
      equation
        alg_1 = inlineAlgorithm(alg,fns);
        res = DAE.INITIALALGORITHM(alg_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.COMP(i,DAE.DAE(elist)) :: cdr,fns)
      equation
        elist_1 = inlineDAEElements(elist,fns);
        res = DAE.COMP(i,DAE.DAE(elist_1));
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.FUNCTION(p,DAE.DAE(elist),t,partialPrefix) :: cdr,fns)
      equation
        elist_1 = inlineDAEElements(elist,fns);
        res = DAE.FUNCTION(p,DAE.DAE(elist_1),t,partialPrefix);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.EXTFUNCTION(p,DAE.DAE(elist),t,ext) :: cdr,fns)
      equation
        elist_1 = inlineDAEElements(elist,fns);
        res = DAE.EXTFUNCTION(p,DAE.DAE(elist_1),t,ext);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.EXTOBJECTCLASS(p,el1,el2) :: cdr,fns)
      equation
        {el1_1} = inlineDAEElements({el1},fns);
        {el2_1} = inlineDAEElements({el2},fns);
        res = DAE.EXTOBJECTCLASS(p,el1_1,el2_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.ASSERT(exp1,exp2) :: cdr,fns)
      equation
        exp1_1 = inlineExp(exp1,fns);
        exp2_1 = inlineExp(exp2,fns);
        res = DAE.ASSERT(exp1_1,exp2_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.TERMINATE(exp) :: cdr,fns)
      equation
        exp_1 = inlineExp(exp,fns);
        res = DAE.TERMINATE(exp_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.REINIT(componentRef,exp) :: cdr,fns)
      equation
        exp_1 = inlineExp(exp,fns);
        res = DAE.REINIT(componentRef,exp_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(DAE.NORETCALL(p,explst) :: cdr,fns)
      equation
        explst_1 = Util.listMap1(explst,inlineExp,fns);
        res = DAE.NORETCALL(p,explst_1);
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        res :: cdr_1;
    case(el :: cdr,fns)
      equation
        cdr_1 = inlineDAEElements(cdr,fns);
      then
        el :: cdr_1;
  end matchcontinue;
end inlineDAEElements;

protected function inlineAlgorithm
"function: inlineAlgorithm
	inline calls in an Algorithm.Algorithm"
	input Algorithm.Algorithm inAlgorithm;
	input list<DAE.Element> inElementList;
	output Algorithm.Algorithm outAlgorithm;
algorithm
  outAlgorithm := matchcontinue(inAlgorithm,inElementList)
    local
      list<Algorithm.Statement> stmts,stmts_1;
      list<DAE.Element> fns;
    case(Algorithm.ALGORITHM(stmts),fns)
      equation
        stmts_1 = Util.listMap1(stmts,inlineStatement,fns);
      then
        Algorithm.ALGORITHM(stmts_1);
  end matchcontinue;
end inlineAlgorithm;

protected function inlineStatement
"function: inlineStatement
	inlines calls in an Algorithm.Statement"
	input Algorithm.Statement inStatement;
	input list<DAE.Element> inElementList;
	output Algorithm.Statement outStatement;
algorithm
  outStatement := matchcontinue(inStatement,inElementList)
    local
      list<DAE.Element> fns;
      Algorithm.Statement stmt,stmt_1;
      Exp.Type t;
      Exp.Exp e,e_1,e1,e1_1,e2,e2_1;
      list<Exp.Exp> explst,explst_1;
      Exp.ComponentRef cref;
      Algorithm.Else a_else,a_else_1;
      list<Algorithm.Statement> stmts,stmts_1;
      Boolean b;
      Ident i;
      list<Integer> ilst;
    case(Algorithm.ASSIGN(t,e1,e2),fns)
      equation
        e1_1 = inlineExp(e1,fns);
        e2_1 = inlineExp(e2,fns);
      then
        Algorithm.ASSIGN(t,e1_1,e2_1);
    case(Algorithm.TUPLE_ASSIGN(t,explst,e),fns)
      equation
        explst_1 = Util.listMap1(explst,inlineExp,fns);
        e_1 = inlineExp(e,fns);
      then
        Algorithm.TUPLE_ASSIGN(t,explst_1,e_1);
    case(Algorithm.ASSIGN_ARR(t,cref,e),fns)
      equation
        e_1 = inlineExp(e,fns);
      then
        Algorithm.ASSIGN_ARR(t,cref,e_1);
    case(Algorithm.IF(e,stmts,a_else),fns)
      equation
        e_1 = inlineExp(e,fns);
        stmts_1 = Util.listMap1(stmts,inlineStatement,fns);
        a_else_1 = inlineElse(a_else,fns);
      then
        Algorithm.IF(e_1,stmts_1,a_else_1);
    case(Algorithm.FOR(t,b,i,e,stmts),fns)
      equation
        e_1 = inlineExp(e,fns);
        stmts_1 = Util.listMap1(stmts,inlineStatement,fns);
      then
        Algorithm.FOR(t,b,i,e_1,stmts_1);
    case(Algorithm.WHILE(e,stmts),fns)
      equation
        e_1 = inlineExp(e,fns);
        stmts_1 = Util.listMap1(stmts,inlineStatement,fns);
      then
        Algorithm.WHILE(e_1,stmts_1);
    case(Algorithm.WHEN(e,stmts,SOME(stmt),ilst),fns)
      equation
        e_1 = inlineExp(e,fns);
        stmts_1 = Util.listMap1(stmts,inlineStatement,fns);
        stmt_1 = inlineStatement(stmt,fns);
      then
        Algorithm.WHEN(e_1,stmts_1,SOME(stmt_1),ilst);
    case(Algorithm.WHEN(e,stmts,NONE,ilst),fns)
      equation
        e_1 = inlineExp(e,fns);
        stmts_1 = Util.listMap1(stmts,inlineStatement,fns);
      then
        Algorithm.WHEN(e_1,stmts_1,NONE,ilst);
    case(Algorithm.ASSERT(e1,e2),fns)
      equation
        e1_1 = inlineExp(e1,fns);
        e2_1 = inlineExp(e2,fns);
      then
        Algorithm.ASSERT(e1_1,e2_1);
    case(Algorithm.TERMINATE(e),fns)
      equation
        e_1 = inlineExp(e,fns);
      then
        Algorithm.TERMINATE(e_1);
    case(Algorithm.REINIT(e1,e2),fns)
      equation
        e1_1 = inlineExp(e1,fns);
        e2_1 = inlineExp(e2,fns);
      then
        Algorithm.REINIT(e1_1,e2_1);
    case(Algorithm.NORETCALL(e),fns)
      equation
        e_1 = inlineExp(e,fns);
      then
        Algorithm.NORETCALL(e_1);
    case(Algorithm.TRY(stmts),fns)
      equation
        stmts_1 = Util.listMap1(stmts,inlineStatement,fns);
      then
        Algorithm.TRY(stmts_1);
    case(Algorithm.CATCH(stmts),fns)
      equation
        stmts_1 = Util.listMap1(stmts,inlineStatement,fns);
      then
        Algorithm.CATCH(stmts_1);
    case(Algorithm.MATCHCASES(explst),fns)
      equation
        explst_1 = Util.listMap1(explst,inlineExp,fns);
      then
        Algorithm.MATCHCASES(explst_1);
    case(stmt,_) then stmt;
  end matchcontinue;
end inlineStatement;

protected function inlineElse
"function: inlineElse
	inlines calls in an Algorithm.Else"
	input Algorithm.Else inElse;
	input list<DAE.Element> inElementList;
	output Algorithm.Else outElse;
algorithm
  outElse := matchcontinue(inElse,inElementList)
    local
      list<DAE.Element> fns;
      Algorithm.Else a_else,a_else_1;
      Exp.Exp e,e_1;
      list<Algorithm.Statement> stmts,stmts_1;
    case(Algorithm.ELSEIF(e,stmts,a_else),fns)
      equation
        e_1 = inlineExp(e,fns);
        stmts_1 = Util.listMap1(stmts,inlineStatement,fns);
        a_else_1 = inlineElse(a_else,fns);
      then
        Algorithm.ELSEIF(e_1,stmts_1,a_else_1);
    case(Algorithm.ELSE(stmts),fns)
      equation
        stmts_1 = Util.listMap1(stmts,inlineStatement,fns);
      then
        Algorithm.ELSE(stmts_1);
    case(a_else,fns) then a_else;
  end matchcontinue;
end inlineElse;

protected function inlineExp
"function: inlineExp
	inlines calls in an Exp.Exp"
	input Exp.Exp inExp;
	input list<DAE.Element> inElementList;
	output Exp.Exp outExp;
algorithm
  outExp := matchcontinue(inExp,inElementList)
    local
      list<DAE.Element> fns;
      Exp.Exp e,e_1;
    case(e,fns)
      equation
        ((e_1,fns)) = Exp.traverseExp(e,inlineCall,fns);
      then
        e_1;
    case(e,_) then e;
  end matchcontinue;
end inlineExp;

protected function inlineCall
"function: inlineCall
	replaces an inline call with the expression from the function"
	input tuple<Exp.Exp, list<DAE.Element>> inTuple;
	output tuple<Exp.Exp, list<DAE.Element>> outTuple;
algorithm
  outExp := matchcontinue(inTuple)
    local
      list<DAE.Element> fns,fn;
      Absyn.Path p;
      list<Exp.Exp> args;
      Boolean tup,built;
      Exp.Type t;
      list<Exp.ComponentRef> crefs;
      list<tuple<Exp.ComponentRef, Exp.Exp>> argmap;
      Exp.Exp newExp;
    case((Exp.CALL(p,args,tup,built,t,true),fns))
      equation
        DAE.FUNCTION(_,DAE.DAE(fn),_,_) :: _ = DAEUtil.getNamedFunction(p,fns);
        crefs = Util.listMap(fn,getInputCrefs);
        crefs = Util.listSelect(crefs,removeWilds);
        argmap = Util.listThreadTuple(crefs,args);
        newExp = getRhsExp(fn);
        ((newExp,argmap)) = Exp.traverseExp(newExp,replaceArgs,argmap);
      then
        ((newExp,fns));
    case((newExp,fns)) then ((newExp,fns));
  end matchcontinue;
end inlineCall;

protected function getRhsExp
"function: getRhsExp
	returns the right hand side of an assignment from a function"
	input list<DAE.Element> inElementList;
	output Exp.Exp outExp;
algorithm
  outExp := matchcontinue(inElementList)
    local
      list<DAE.Element> cdr;
      Exp.Exp res;
    case({})
      equation
        Debug.fprintln("failtrace","Inline.getRhsExp failed - cannot inline such a function");
      then
        fail();
    case(DAE.ALGORITHM(Algorithm.ALGORITHM({Algorithm.ASSIGN(_,_,res)})) :: _) then res;
    case(DAE.ALGORITHM(Algorithm.ALGORITHM({Algorithm.TUPLE_ASSIGN(_,_,res)})):: _) then res;
    case(DAE.ALGORITHM(Algorithm.ALGORITHM({Algorithm.ASSIGN_ARR(_,_,res)})) :: _) then res;
    case(_ :: cdr)
      equation
        res = getRhsExp(cdr);
      then
        res;
  end matchcontinue;
end getRhsExp;

protected function replaceArgs
"function: replaceArgs
	finds Exp.CREF and replaces them with new exps if the cref is in the argmap"
	input tuple<Exp.Exp, list<tuple<Exp.ComponentRef, Exp.Exp>>> inTuple;
	output tuple<Exp.Exp, list<tuple<Exp.ComponentRef, Exp.Exp>>> outTuple;
algorithm
  outTuple := matchcontinue(inTuple)
    local
      list<DAE.Element> fns;
      Exp.ComponentRef cref;
      list<tuple<Exp.ComponentRef, Exp.Exp>> argmap;
      Exp.Exp e;
    case((Exp.CREF(componentRef = cref),argmap))
      equation
        e = getExpFromArgMap(argmap,cref);
      then
        ((e,argmap));
    case((e,argmap)) then ((e,argmap));
  end matchcontinue;
end replaceArgs;

protected function getExpFromArgMap
"function: getExpFromArgMap
	returns the exp from the given argmap with the given key"
	input list<tuple<Exp.ComponentRef, Exp.Exp>> inArgMap;
	input Exp.ComponentRef inComponentRef;
	output Exp.Exp outExp;
algorithm
  outExp := matchcontinue(inArgMap,inComponentRef)
    local
      Exp.ComponentRef key,cref;
      Exp.Exp exp;
      list<tuple<Exp.ComponentRef, Exp.Exp>> cdr;
    case({},_)
      equation
        Debug.fprintln("failtrace","Inline.getExpFromArgMap failed");
      then
        fail();
    case((cref,exp) :: cdr,key)
      equation
        true = Exp.crefEqual(cref,key);
      then
        exp;
    case(_ :: cdr,key)
      equation
        exp = getExpFromArgMap(cdr,key);
      then
        exp;
  end matchcontinue;
end getExpFromArgMap;

protected function getInputCrefs
"function: getInputCrefs
	returns the crefs of vars that are inputs, wild if not input"
	input DAE.Element inElement;
	output Exp.ComponentRef outComponentRef;
algorithm
  outComponentRef := matchcontinue(inElement)
    local
      Exp.ComponentRef cref;
    case(DAE.VAR(componentRef=cref,direction=DAE.INPUT())) then cref;
    case(_) then Exp.WILD();
  end matchcontinue;
end getInputCrefs;

protected function removeWilds
"function: removeWilds
	returns false if the given cref is a wild"
	input Exp.ComponentRef inComponentRef;
	output Boolean outBoolean;
algorithm
  outBoolean := matchcontinue(inComponentRef)
    case(Exp.WILD()) then false;
    case(_) then true;
  end matchcontinue;
end removeWilds;








end Inline;