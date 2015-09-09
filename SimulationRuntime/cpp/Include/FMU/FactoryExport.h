#pragma once
/** @addtogroup coreSystem
 *
 *  @{
 */

#if defined(__vxworks)

#define BOOST_EXTENSION_SOLVER_DECL
#define BOOST_EXTENSION_SOLVERSETTINGS_DECL

#elif defined(RUNTIME_STATIC_LINKING) && (defined(OMC_BUILD) || defined(SIMSTER_BUILD))
#define BOOST_EXTENSION_LOGGER_DECL

#elif defined(OMC_BUILD) || defined(SIMSTER_BUILD)
#define BOOST_EXTENSION_LOGGER_DECL BOOST_EXTENSION_IMPORT_DECL
#else
    error "operating system not supported"
#endif

/** @} */ // end of coreSystem
