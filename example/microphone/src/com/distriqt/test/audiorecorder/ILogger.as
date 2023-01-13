/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * http://distriqt.com
 *
 * @file   		ILogger.as
 * @brief  		
 * @author 		Michael Archbold (https://github.com/marchbold)
 * @created		26/03/2015
 * @updated		$Date:$
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.audiorecorder
{
	/**
	 * @author 	Michael Archbold (https://github.com/marchbold)
	 */
	public interface ILogger
	{
		
		function log( tag:String, message:String ):void;
	}
}