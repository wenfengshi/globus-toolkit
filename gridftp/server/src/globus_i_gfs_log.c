
#include "globus_i_gridftp_server.h"

/**
 * should select logging based on configuration.  log output funcs should
 * still be usable before this and will output to stderr.
 * 
 * if this fails, just print to stderr.
 */
void
globus_i_gfs_log_open(void)
{
    
}

void
globus_i_gfs_log_close(void)
{
    
}

void
globus_i_gfs_log_message(
    globus_i_gfs_log_type_t             type,
    const char *                        format,
    ...)
{
    va_list                             ap;
    
    va_start(ap, format);
    
    if(!globus_i_gfs_config_bool("inetd") && !globus_i_gfs_config_bool("detach"))
    {
        globus_libc_vfprintf(stderr, format, ap);
    }
    va_end(ap);
}
void
globus_i_gfs_log_entry(
    globus_i_gfs_server_instance_t *    instance,
    const char *                        message,
    globus_i_gfs_log_type_t             type)
{
   
    globus_i_gfs_log_message(
        type, 
        "%s: %s", 
        instance->remote_contact, 
        message);
    
    return;
}

void
globus_i_gfs_log_result(
    const char *                        lead,
    globus_result_t                     result)
{
    char *                              message;
    
    message = globus_error_print_friendly(globus_error_peek(result));
    globus_i_gfs_log_message(GLOBUS_I_GFS_LOG_ERR, "%s:\n%s\n", lead, message);
    globus_free(message);
}
