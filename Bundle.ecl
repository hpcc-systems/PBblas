IMPORT Std;
EXPORT Bundle := MODULE(Std.BundleBase)
 EXPORT Name := 'PBblas';
 EXPORT Description := 'Parallel Block Basic Linear Algebra Subsystem';
 EXPORT Authors := ['HPCCSystems'];
 EXPORT License := 'http://www.apache.org/licenses/LICENSE-2.0';
 EXPORT Copyright := 'Copyright (C) 2020 HPCC Systems';
 EXPORT DependsOn := ['ML_Core'];
 EXPORT Version := '3.1';
 EXPORT PlatformVersion := '6.2.0';
END;