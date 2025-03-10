 % 
 %  MIT License
 % 
 %  Copyright (c) 2025 Takuya Otani
 % 
 %  Permission is hereby granted, free of charge, to any person obtaining a copy
 %  of this software and associated documentation files (the "Software"), to deal
 %  in the Software without restriction, including without limitation the rights
 %  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 %  copies of the Software, and to permit persons to whom the Software is
 %  furnished to do so, subject to the following conditions:
 % 
 %  The above copyright notice and this permission notice shall be included in all
 %  copies or substantial portions of the Software.
 % 
 %  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 %  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 %  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 %  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 %  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 %  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 %  SOFTWARE.
 % 

%List M5 Stack in BLE
list = blelist("Name","StampFly_BLE");

%Connect to the device
m5 = ble(list.Address);
%m5.Characteristics

ServiceUUID = "1A8E4E30-DEF4-4D96-A1F4-7E6101B7EEA4";
characteristicUID = "8F9A9BC0-2BDD-40DD-8BB5-CB9D4E3799FF";  % For interacting data to/from StampFly

% Get the characteristic for writing (send data)
data_c = characteristic(m5, ServiceUUID, characteristicUID);

%% Here, continue to receive data from StampFly and draw StampFly status

disp('Press Ctrl+C to stop.');

% Open a plot figure window. 
% poseplot() is from Navigation Toolbox 
% https://jp.mathworks.com/help/nav/ref/poseplot.html

ax = poseplot(ones("quaternion"),[0 0 0],MeshFileName="multirotor.stl",ScaleFactor=0.5);

% Main loop (polling for data)
while true
    try
        % Read raw BLE data (88 bytes expected)
        
        rawData = read(data_c);

        if length(rawData) == 88
            % Convert raw bytes to float values
            %elapsed_time  = typecast(uint8(rawData(1:4)), 'single');
            %interval_time = typecast(uint8(rawData(5:8)), 'single');

            roll_angle     = typecast(uint8(rawData(9:12)), 'single');
            pitch_angle    = typecast(uint8(rawData(13:16)), 'single');
            yaw_angle      = typecast(uint8(rawData(17:20)), 'single');

            %roll_rate     = typecast(uint8(rawData(21:24)), 'single');
            %pitch_rate    = typecast(uint8(rawData(25:28)), 'single');
            %yaw_rate      = typecast(uint8(rawData(29:32)), 'single');
            %accx          = typecast(uint8(rawData(33:36)), 'single');
            %accy          = typecast(uint8(rawData(37:40)), 'single');
            %accz          = typecast(uint8(rawData(41:44)), 'single');
            %Alt_velocity  = typecast(uint8(rawData(45:48)), 'single');
            %Z_dot_ref     = typecast(uint8(rawData(49:52)), 'single');
            %Alt_ref       = typecast(uint8(rawData(53:56)), 'single');
            %Altitude2     = typecast(uint8(rawData(57:60)), 'single');
            %Altitude      = typecast(uint8(rawData(61:64)), 'single');
            %Az            = typecast(uint8(rawData(65:68)), 'single');
            %Az_bias       = typecast(uint8(rawData(69:72)), 'single');
            %Alt_flag      = typecast(uint8(rawData(73:76)), 'single');
            %Mode          = typecast(uint8(rawData(77:80)), 'single');
            %RangeFront    = typecast(uint8(rawData(81:84)), 'single');
            %Voltage       = typecast(uint8(rawData(85:88)), 'single');

             q = quaternion([roll_angle pitch_angle yaw_angle],"eulerd", "XYZ","point");
            ax.Orientation = q;

        end
    catch ME
        disp(['Error reading data: ', ME.message]);
    end

    pause(1/400);  % Poll every 1/400 second
end