/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-CurrentYear, Linköping University,
 * Department of Computer and Information Science,
 * SE-58183 Linköping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF GPL VERSION 3
 * AND THIS OSMC PUBLIC LICENSE (OSMC-PL).
 * ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES RECIPIENT'S
 * ACCEPTANCE OF THE OSMC PUBLIC LICENSE.
 *
 * The OpenModelica software and the Open Source Modelica
 * Consortium (OSMC) Public License (OSMC-PL) are obtained
 * from Linköping University, either from the above address,
 * from the URLs: http://www.ida.liu.se/projects/OpenModelica or
 * http://www.openmodelica.org, and in the OpenModelica distribution.
 * GNU version 3 is obtained from: http://www.gnu.org/copyleft/gpl.html.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without
 * even the implied warranty of  MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE, EXCEPT AS EXPRESSLY SET FORTH
 * IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE CONDITIONS
 * OF OSMC-PL.
 *
 * See the full OSMC Public License conditions for more details.
 *
 */

/*
 * OpenModelica Optimization (Ver 0.1)
 * Last Modification: 05. September 2013
 *
 * Developed by:
 * FH-Bielefeld
 * Developer: Vitalij Ruge
 * Contact: vitalij.ruge@fh-bielefeld.de
 */

#include "../ipoptODEstruct.h"
#include "../localFunction.h"



#ifdef WITH_IPOPT
#define DF_STEP(x,s) ( (fmin(fmax(1e-4*fabs(s*x),1e-8),1e-1)))
static inline void evalG11(Number *g, IPOPT_DATA_ *iData, int i);
static inline void evalG12(Number *g, IPOPT_DATA_ *iData, int i);
static inline void evalG13(Number *g, IPOPT_DATA_ *iData, int i);
static inline void evalG21(Number *g, IPOPT_DATA_ *iData, int i);
static inline void evalG22(Number *g, IPOPT_DATA_ *iData, int i);
static inline void evalG23(Number *g, IPOPT_DATA_ *iData, int i);
static int diff_symColoredODE(double *v, int k, IPOPT_DATA_ *iData, long double **J);
static int num_diff_symColoredODE(double *v, int k, IPOPT_DATA_ *iData, double **J);
static void printMaxError(IPOPT_DATA_ *iData, double *g,double time, double * max_err , double * tt, int *xi);

/*!
 *  eval s.t.
 *  author: Vitalij Ruge
 **/
Bool evalfG(Index n, double * v, Bool new_x, int m, Number *g, void * useData)
{
   IPOPT_DATA_ *iData;
   int i,k,j;

   double max_err = -1;
   double max_err_time = -1;
   int max_err_xi = -1;

   int tmp_index;

   OPTIMIZER_DIM_VARS* dim;
   OPTIMIZER_TIME *dtime;
   OPTIMIZER_MBASE *mbase;


   iData = (IPOPT_DATA_ *) useData;
   dim = &iData->dim;
   dtime = &iData->dtime;
   mbase = &iData->mbase;


   for(i=0, k=0, mbase->x[0] = v; i<1; ++i, mbase->x[0] = mbase->x[dim->deg]){
     for(j = 1; j <dim->deg+1; ++j)
       mbase->x[j] = mbase->x[j-1] + dim->nv;

     for(j = 0; j <dim->deg+1; ++j)
       mbase->u[j] = mbase->x[j] + dim->nx;

     for(j = 0; j <2; ++j)
       functionODE_(mbase->x[j], mbase->u[j], j, mbase->dotx[j], iData);

     /*1*/
     evalG21(g + k, iData, i);
     if(ACTIVE_STREAM(LOG_IPOPT_ERROR))
       printMaxError(iData,g,dtime->time[1],&max_err, &max_err_time, &max_err_xi);
     k += dim->nJ;

     /*2*/
     functionODE_(mbase->x[2], mbase->u[2], 2, mbase->dotx[2], iData);
     evalG22(g + k, iData, i);
     if(ACTIVE_STREAM(LOG_IPOPT_ERROR))
       printMaxError(iData,g,dtime->time[2],&max_err, &max_err_time, &max_err_xi);
     k += dim->nJ;

     /*3*/
     functionODE_(mbase->x[3], mbase->u[3], 3, mbase->dotx[3], iData);
     evalG23(g + k, iData, i);
     if(ACTIVE_STREAM(LOG_IPOPT_ERROR))
       printMaxError(iData,g,dtime->time[3],&max_err, &max_err_time, &max_err_xi);
     k += dim->nJ;
  }

  for(; i<dim->nsi; ++i, mbase->x[0] = mbase->x[dim->deg]){

    tmp_index = i*dim->deg;

    for(j = 1; j <dim->deg+1; ++j)
      mbase->x[j] = mbase->x[j-1] + dim->nv;

    for(j = 0; j <dim->deg+1; ++j)
      mbase->u[j] = mbase->x[j] + dim->nx;

    /*1*/
    functionODE_(mbase->x[1], mbase->u[1], tmp_index + 1, mbase->dotx[1], iData);
    evalG11(g + k, iData, i);
    if(ACTIVE_STREAM(LOG_IPOPT_ERROR))
      printMaxError(iData,g, dtime->time[tmp_index + 1],&max_err, &max_err_time, &max_err_xi);
    k += dim->nJ;

    /*2*/
    functionODE_(mbase->x[2], mbase->u[2], tmp_index + 2, mbase->dotx[2], iData);
    evalG12(g + k, iData, i);
    if(ACTIVE_STREAM(LOG_IPOPT))
      printMaxError(iData,g,dtime->time[tmp_index + 2],&max_err, &max_err_time, &max_err_xi);
    k += dim->nJ;

    /*3*/
    functionODE_(mbase->x[3], mbase->u[3], tmp_index + 3, mbase->dotx[3], iData);
    evalG13(g + k, iData, i);
    if(ACTIVE_STREAM(LOG_IPOPT_ERROR))
      printMaxError(iData,g,dtime->time[tmp_index + 3],&max_err, &max_err_time, &max_err_xi);
    k += dim->nJ;
  }
  if(ACTIVE_STREAM(LOG_IPOPT_ERROR)){

    if(max_err_xi < dim->nx)
      printf("\nmax error for |%s(%g) - collocation_poly| = %g\n",iData->data->modelData.realVarsData[max_err_xi].info.name,max_err_time,max_err);
    else
      printf("\nmax error for |cosntrain[%i](%g)| = %g\n", (int)max_err_xi-(int)dim->nx, max_err_time, max_err);
  }
  return TRUE;
}

/*!
 *  eval modell ODE
 *  author: Vitalij Ruge
 **/
int functionODE_(double * x, double *u, int k, double * dotx, IPOPT_DATA_ *iData)
{
  SIMULATION_DATA *sData = (SIMULATION_DATA*)iData->data->localData[0];
  refreshSimData(x, u, k, iData);
  memcpy(dotx, sData->realVars + iData->dim.nx, sizeof(double)*iData->dim.nx);
  return 0;
}

/*!
 *  eval a part from the derivate of s.t.
 *  author: Vitalij Ruge
 **/
int diff_functionODE(double* v, int k, IPOPT_DATA_ *iData, long double **J)
{
  int i, j;
  double *x, *u;
  x = v;
  u = v + iData->dim.nx;

  refreshSimData(x,u,k,iData);
  diff_symColoredODE(v,k,iData,J);

  /*
  #ifdef JAC_ADOLC
  for(j = 0; j<iData->nv;++j)
    iData->sv[j] = v[j]*iData->vnom[j];

  jacobian(0, iData->nx, iData->nv, iData->sv, iData->J);
  for(i = 0;i<iData->nv;++i)
    for(j = 0; j <iData->nx; ++j)
      J[j][i] *= iData->scalf[j]*iData->vnom[i];
  #endif
  */

  return 0;
}

/*
 *  function calculates a symbolic colored jacobian matrix by
 *  author: Willi Braun
 */
int diff_symColoredODE(double *v, int k, IPOPT_DATA_ *iData, long double **J)
{
  DATA * data = iData->data;
  const int index = 2;

  int i,j,l,ii,nx;
  int *cC,*lindex;

  nx = data->simulationInfo.analyticJacobians[index].sizeCols;
  cC =  (int*)data->simulationInfo.analyticJacobians[index].sparsePattern.colorCols;
  lindex = (int*)data->simulationInfo.analyticJacobians[index].sparsePattern.leadindex;

  for(i = 1; i < data->simulationInfo.analyticJacobians[index].sparsePattern.maxColors + 1; ++i){
    for(ii = 0; ii<nx; ++ii){
      if(cC[ii] == i){
        data->simulationInfo.analyticJacobians[index].seedVars[ii] = iData->scaling.vnom[ii];
      }
    }

    data->callback->functionJacB_column(data);

    for(ii = 0; ii < nx; ii++){
      if(cC[ii] == i){
        if(ii == 0)  j = 0;
        else j = lindex[ii-1];

        for(; j<lindex[ii]; ++j){
          l = data->simulationInfo.analyticJacobians[index].sparsePattern.index[j];
          if(l < iData->dim.nx)
            J[l][ii] = data->simulationInfo.analyticJacobians[index].resultVars[l]*iData->scaling.scalf[l];
          else
            J[l][ii] = data->simulationInfo.analyticJacobians[index].resultVars[l];
        }
      }
    }

    for(ii = 0; ii<nx; ++ii){
      if(cC[ii] == i){
        data->simulationInfo.analyticJacobians[index].seedVars[ii] = 0.0;
      }
    }
  }


  return 0;
}


/*!
 *  helper evalfG
 *  author: Vitalij Ruge
 **/
static inline void evalG11(Number *g, IPOPT_DATA_ *iData, int i)
{
  int j;
  OPTIMIZER_MBASE *mbase = & iData->mbase;

  for(j=0; j<iData->dim.nx; ++j)
    g[j] = (mbase->a[0][0]*mbase->x[0][j] + mbase->a[0][3]*mbase->x[3][j] + iData->scaling.scaldt[j][i]*mbase->dotx[1][j]) -
            (mbase->a[0][1]*mbase->x[1][j] + mbase->a[0][2]*mbase->x[2][j]);

  memcpy(g + iData->dim.nx, &iData->data->localData[0]->realVars[iData->data->modelData.nVariablesReal - iData->dim.nc], sizeof(double)*iData->dim.nc);

}

/*!
 *  helper evalfG
 *  author: Vitalij Ruge
 **/
static inline void evalG12(Number *g, IPOPT_DATA_ *iData, int i)
{
  int j;
  OPTIMIZER_MBASE *mbase = &iData->mbase;

  for(j=0; j<iData->dim.nx; ++j)
    g[j] = (mbase->a[1][1]*mbase->x[1][j] +
        iData->scaling.scaldt[j][i]*mbase->dotx[2][j])
        - (mbase->a[1][0]*mbase->x[0][j] + mbase->a[1][2]*mbase->x[2][j] +
            mbase->a[1][3]*mbase->x[3][j]);

  memcpy(g + iData->dim.nx, &iData->data->localData[0]->realVars[iData->data->modelData.nVariablesReal - iData->dim.nc], sizeof(double)*iData->dim.nc);

}

/*!
 *  helper evalfG
 *  author: Vitalij Ruge
 **/
static inline void evalG13(Number *g, IPOPT_DATA_ *iData, int i)
{
  int j;
  OPTIMIZER_MBASE *mbase = &iData->mbase;

  for(j=0; j<iData->dim.nx; ++j)
    g[j] = (mbase->a[2][0]*mbase->x[0][j] +
            mbase->a[2][2]*mbase->x[2][j] +
            iData->scaling.scaldt[j][i]*mbase->dotx[3][j]) -
            (mbase->a[2][1]*mbase->x[1][j] + mbase->a[2][3]*mbase->x[3][j]);

  memcpy(g + iData->dim.nx, &iData->data->localData[0]->realVars[iData->data->modelData.nVariablesReal - iData->dim.nc], sizeof(double)*iData->dim.nc);
}

/*!
 *  helper evalfG
 *  author: Vitalij Ruge
 **/
static inline void evalG21(Number *g, IPOPT_DATA_ *iData, int i)
{
  int j;
  OPTIMIZER_MBASE *mbase = &iData->mbase;

  for(j=0; j<iData->dim.nx; ++j)
    g[j] = (iData->scaling.scaldt[j][i]*(mbase->dotx[1][j] + mbase->d[0][4]*mbase->dotx[0][j])
            + mbase->d[0][0]*mbase->x[0][j] + mbase->d[0][3]*mbase->x[3][j])
            - (mbase->d[0][1]*mbase->x[1][j] + mbase->d[0][2]*mbase->x[2][j]);

  memcpy(g + iData->dim.nx, &iData->data->localData[0]->realVars[iData->data->modelData.nVariablesReal - iData->dim.nc], sizeof(double)*iData->dim.nc);

}

/*!
 *  helper evalfG
 *  author: Vitalij Ruge
 **/
static inline void evalG22(Number *g, IPOPT_DATA_ *iData, int i)
{
  int j;
  OPTIMIZER_MBASE *mbase = &iData->mbase;
  for(j=0; j<iData->dim.nx; ++j)
    g[j] = (iData->scaling.scaldt[j][i]*mbase->dotx[2][j] + mbase->d[1][1]*mbase->x[1][j])
          - (iData->scaling.scaldt[j][i]*mbase->d[1][4]*mbase->dotx[0][j] + mbase->d[1][0]*mbase->x[0][j] +
              mbase->d[1][2]*mbase->x[2][j]
          + mbase->d[1][3]*mbase->x[3][j]);

  memcpy(g + iData->dim.nx, &iData->data->localData[0]->realVars[iData->data->modelData.nVariablesReal - iData->dim.nc], sizeof(double)*iData->dim.nc);

}

/*!
 *  helper evalfG
 *  author: Vitalij Ruge
 **/
static inline void evalG23(Number *g, IPOPT_DATA_ *iData, int i)
{
  int j;
  OPTIMIZER_MBASE *mbase = &iData->mbase;

  for(j=0; j<iData->dim.nx; ++j)
    g[j] = (iData->scaling.scaldt[j][i]*(mbase->d[2][4]*mbase->dotx[0][j] + mbase->dotx[3][j])
        + mbase->d[2][0]*mbase->x[0][j] + mbase->d[2][2]*mbase->x[2][j]) -
        (mbase->d[2][1]*mbase->x[1][j] + mbase->d[2][3]*mbase->x[3][j]);

  memcpy(g + iData->dim.nx, &iData->data->localData[0]->realVars[iData->data->modelData.nVariablesReal - iData->dim.nc], sizeof(double)*iData->dim.nc);
  // return 0;
}

static void printMaxError(IPOPT_DATA_ *iData, double *g,double t, double * max_err, double * tt, int *xi)
{
  double tmp;
  int j;

  for(j = 0; j<iData->dim.nx; ++j){
    tmp = fabs(g[j]);
    if(tmp > *max_err){
      *max_err = tmp;
      *tt = t;
      *xi = j;
    }
  }

  for(; j<iData->dim.nJ; ++j){
    if(g[j]> *max_err){
      *max_err = g[j];
      *tt = t;
      *xi = j;
    }
  }
}


#undef DF_STEP
#endif
