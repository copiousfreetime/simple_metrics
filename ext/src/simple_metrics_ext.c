#include "simple_metrics_ext.h"

/* classes defined here */
VALUE mSM;         /* SimpleMetrics */
VALUE mSM_Metric;  /* SimpleMetrics::Metric */
VALUE mSME;        /* SimpleMetrics::Ext */
VALUE cSME_Metric; /* SimpleMetrics::Ext::Metric */

VALUE sm_free( simple_metrics* sm )
{
    simple_metrics_free( sm );
    return Qnil;
}

VALUE sm_alloc( VALUE klass )
{
    VALUE obj;
    simple_metrics* sm = simple_metrics_new();

    obj = Data_Wrap_Struct( klass, NULL, sm_free, sm );

    return obj;
}


VALUE sm_initialize( VALUE self, VALUE name )
{

    rb_call_super( 1, &name );
    return self;
}


VALUE sm_update( VALUE self, VALUE v )
{
    double          new_v = NUM2DBL( v );
    simple_metrics *sm;

    Data_Get_Struct( self, simple_metrics, sm );

    simple_metrics_update( sm, new_v );

    return Qnil;
}

VALUE sm_count( VALUE self )
{
    simple_metrics *sm;
    long            result;
    VALUE           r;
    
    Data_Get_Struct( self, simple_metrics, sm );
    result = simple_metrics_count( sm );
    r      = LONG2NUM( result );

    return r;
}

VALUE sm_min( VALUE self )
{
    simple_metrics *sm;
    double          result;
    VALUE           r;
    
    Data_Get_Struct( self, simple_metrics, sm );
    result = simple_metrics_min( sm );
    r      = rb_float_new(  result );

    return r;
}


VALUE sm_max( VALUE self )
{
    simple_metrics *sm;
    double          result;
    VALUE           r;
    
    Data_Get_Struct( self, simple_metrics, sm );
    result = simple_metrics_max( sm );
    r      = rb_float_new(  result );

    return r;
}

VALUE sm_mean( VALUE self )
{
    simple_metrics *sm;
    double          result;
    VALUE           r;
    
    Data_Get_Struct( self, simple_metrics, sm );
    result = simple_metrics_mean( sm );
    r      = rb_float_new(  result );

    return r;
}


VALUE sm_rate( VALUE self )
{
    simple_metrics *sm;
    double          result;
    VALUE           r;
    
    Data_Get_Struct( self, simple_metrics, sm );
    result = simple_metrics_rate( sm );
    r      = rb_float_new(  result );

    return r;
}


VALUE sm_sum( VALUE self )
{
    simple_metrics *sm;
    double          result;
    VALUE           r;
    
    Data_Get_Struct( self, simple_metrics, sm );
    result = simple_metrics_sum( sm );
    r      = rb_float_new(  result );

    return r;
}


VALUE sm_stddev( VALUE self )
{
    simple_metrics *sm;
    double          result;
    VALUE           r;
    
    Data_Get_Struct( self, simple_metrics, sm );
    result = simple_metrics_stddev( sm );
    r      = rb_float_new(  result );

    return r;
}


void Init_simple_metrics_ext()
{
    VALUE cSM_Common;

    mSM  = rb_define_module( "SimpleMetrics" );
    mSME = rb_define_module_under( mSM, "Ext" );

    /* load the class we inherit from */
    rb_require("simplemetrics/metric");

    cSM_Common = rb_const_get( mSM, rb_intern( "Common" ) );

    cSME_Metric = rb_define_class_under( mSME, "Metric", cSM_Common );

    rb_define_alloc_func(cSME_Metric, sm_alloc); 
    rb_define_method( cSME_Metric, "initialize", sm_initialize, 1 );
    rb_define_method( cSME_Metric, "update", sm_update, 1 );
    rb_define_method( cSME_Metric, "count", sm_count, 0 );
    rb_define_method( cSME_Metric, "max", sm_max, 0 );
    rb_define_method( cSME_Metric, "min", sm_min, 0 );
    rb_define_method( cSME_Metric, "mean", sm_mean, 0 );
    rb_define_method( cSME_Metric, "rate", sm_rate, 0 );
    rb_define_method( cSME_Metric, "sum", sm_sum, 0 );
    rb_define_method( cSME_Metric, "stddev", sm_stddev, 0 );

}
