#include "mex.h"

#include <cmath>
#include <cstdlib>
#include <cstring>

// mexFeatureDistance( f1, f2, 'x1' )
// where each column in f1 and f2 is a sample
// i.e., size(f1, 1) == feature_dimension  行表示特征维数
//       size(f1, 2) == sample_number      列表示样本数量
// e1样本1，e2样本2，iDim特征维数，distType距离类型
double Distance( double *e1, double *e2, int iDim, const char *distType );

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, 
  const mxArray *prhs[] )
{
    if( nrhs != 3 )
    {
        mexPrintf( "usage: %s f1 f2 dist_type\n" );
        return;  //跳出程序
    }
  //判断第二个输入参数是否为空，为空则为true，否则为false
    bool isSameFeature = mxIsEmpty( prhs[1] );  
    
    double *f1 = (double*)mxGetData( prhs[0] ); //指针f1指向第一个输入参数
    int iSample = mxGetN( prhs[0] ); //获取第一个输入参数的列即样本数量
    int iDim = mxGetM( prhs[0] );  //获取第一个输入参数的行即特征的维数
    
    double *f2 = f1;
    
    if( !isSameFeature )
    {
        f2 = (double*)mxGetData( prhs[1] );
   
        if( mxGetN(prhs[1]) != iSample || mxGetM(prhs[1]) != iDim )
        {
            mexErrMsgTxt( "The dimension of f1 and f2 are not matched." );
            return;
        }
    }
    
    char distType[10];
    mxGetString( prhs[2], distType, 10 );
    
    // mexPrintf( "Sample: %d, iDim: %d, distType: %s\n", iSample, iDim, distType );
    
    //创建二维数组plhs，大小spnum xspnum
    plhs[0] = mxCreateDoubleMatrix( iSample, iSample, mxREAL );
    double *distMat = (double*)mxGetData( plhs[0] );
    
    if( isSameFeature )
    {
        for( int ix = 0; ix < iSample; ++ix )
        {
            for( int jx = 0; jx < iSample; ++jx )
            {
                if( ix == jx )
                    distMat[ix * iSample + jx] = 0.0;
                if( ix < jx )
                    distMat[ix * iSample + jx] = Distance( f1 + ix * iDim, f2 + jx * iDim, iDim, distType );
                else
                    distMat[ix * iSample + jx] = distMat[jx * iSample + ix]; //对称矩阵
            }
        }
    }
    else
    {
        for( int ix = 0; ix < iSample; ++ix )
        {
            for( int jx = 0; jx < iSample; ++jx )
            {
                distMat[jx * iSample + ix] = Distance( f1 + ix * iDim, f2 + jx * iDim, iDim, distType );
            }
        }
    }
}

double Distance( double *e1, double *e2, int iDim, const char *distType )
{
    using namespace std;
    
    const double eps = mxGetEps(); //eps无穷小
    
    double dist = 0.0;
    if( strcmp(distType, "L1" ) == 0 ) //如果distType='L1'
    {
        for( int dim = 0; dim < iDim; ++dim )
            dist += fabs( e1[dim] - e2[dim] ); //向量的1范数
    }
    else if( strcmp(distType, "L2" ) == 0 ) //如果distType='L2'
    {
        for( int dim = 0; dim < iDim; ++dim )
            dist += ( e1[dim] - e2[dim] ) * ( e1[dim] - e2[dim] ); //向量的2范数(不开根号)
    }
    else if( strcmp(distType, "x2" ) == 0 ) //如果distType='x2'
    {
        for( int dim = 0; dim < iDim; ++dim )
            dist += ( e1[dim] - e2[dim] ) * ( e1[dim] - e2[dim] ) / ( e1[dim] + e2[dim] + eps );
        dist /= 2.0;
    }
    else
    {
        mexErrMsgTxt( "Not supported feature distance type." );
        return -1.0;
    }
    
    return dist;
}