#ifndef XYTimeIncluded
#define XYTimeIncluded

#define mod(a, b) ModuloInteger(a, b)
//! zinc
library XYTime {
    private integer
        monthCount[], monthCountLeap[];

    private constant integer
        lengthYear = 31556926, lengthDay = 86400, lengthHour = 3600, lengthMinute = 60;

    private function onInit() {
        monthCount[0] = 0;
        monthCount[1] = monthCount[0] + 31;
        monthCount[2] = monthCount[1] + 28;
        monthCount[3] = monthCount[2] + 31;
        monthCount[4] = monthCount[3] + 30;
        monthCount[5] = monthCount[4] + 31;
        monthCount[6] = monthCount[5] + 30;
        monthCount[7] = monthCount[6] + 31;
        monthCount[8] = monthCount[7] + 31;
        monthCount[9] = monthCount[8] + 30;
        monthCount[10] = monthCount[9] + 31;
        monthCount[11] = monthCount[10] + 30;
        monthCount[12] = monthCount[11] + 31;

        monthCountLeap[0] = 0;
        monthCountLeap[1] = monthCountLeap[0] + 31;
        monthCountLeap[2] = monthCountLeap[1] + 29;
        monthCountLeap[3] = monthCountLeap[2] + 31;
        monthCountLeap[4] = monthCountLeap[3] + 30;
        monthCountLeap[5] = monthCountLeap[4] + 31;
        monthCountLeap[6] = monthCountLeap[5] + 30;
        monthCountLeap[7] = monthCountLeap[6] + 31;
        monthCountLeap[8] = monthCountLeap[7] + 31;
        monthCountLeap[9] = monthCountLeap[8] + 30;
        monthCountLeap[10] = monthCountLeap[9] + 31;
        monthCountLeap[11] = monthCountLeap[10] + 30;
        monthCountLeap[12] = monthCountLeap[11] + 31;
    }

    private function GetYearPlus(integer timeStamp) -> integer {
        return timeStamp / lengthYear;
    }
    private function GetYear(integer timeStamp) -> integer {
        return 1970 + GetYearPlus(timeStamp);
    }
    private function IsLeapYear(integer timeStamp) -> boolean {
        integer year = GetYear(timeStamp);
        if (mod(year, 4) == 0) {
            if (mod(year, 100) == 0) {
                return mod(year, 400) == 0;
            }
            return true;
        }
        return false;
    }
    private function GetLastDays(integer timeStamp) -> integer {
        integer lastTime = mod(timeStamp, lengthYear);
        integer extraAdd = 0; // 只要超过mod值，一律进一天
        if (mod(lastTime, lengthDay) > 0) { extraAdd = 1; }

        return lastTime / lengthDay + extraAdd;
    }
    private function GetMonth(integer timeStamp) -> integer {
        integer
            lastDays = GetLastDays(timeStamp),
            month = 0;

        if (IsLeapYear(timeStamp)) {
            if (lastDays > monthCount[0]) { month += 1; }
            if (lastDays > monthCount[1]) { month += 1; }
            if (lastDays > monthCount[2]) { month += 1; }
            if (lastDays > monthCount[3]) { month += 1; }
            if (lastDays > monthCount[4]) { month += 1; }
            if (lastDays > monthCount[5]) { month += 1; }
            if (lastDays > monthCount[6]) { month += 1; }
            if (lastDays > monthCount[7]) { month += 1; }
            if (lastDays > monthCount[8]) { month += 1; }
            if (lastDays > monthCount[9]) { month += 1; }
            if (lastDays > monthCount[10]) { month += 1; }
            if (lastDays > monthCount[11]) { month += 1; }
        }
        else {
            if (lastDays > monthCountLeap[0]) { month += 1; }
            if (lastDays > monthCountLeap[1]) { month += 1; }
            if (lastDays > monthCountLeap[2]) { month += 1; }
            if (lastDays > monthCountLeap[3]) { month += 1; }
            if (lastDays > monthCountLeap[4]) { month += 1; }
            if (lastDays > monthCountLeap[5]) { month += 1; }
            if (lastDays > monthCountLeap[6]) { month += 1; }
            if (lastDays > monthCountLeap[7]) { month += 1; }
            if (lastDays > monthCountLeap[8]) { month += 1; }
            if (lastDays > monthCountLeap[9]) { month += 1; }
            if (lastDays > monthCountLeap[10]) { month += 1; }
            if (lastDays > monthCountLeap[11]) { month += 1; }
        }

        return month;
    }
    private function GetMonthIncludedDaysTotal(integer timeStamp) -> integer {
        integer month = GetMonth(timeStamp) - 1; // -1: calculate before, do not include current month
        if (IsLeapYear(timeStamp)) {
            return monthCountLeap[month];
        }
        else {
            return monthCount[month];
        }
    }
    private function GetDay(integer timeStamp) -> integer {
        integer lastDays = GetLastDays(timeStamp);
        integer monthCount = GetMonthIncludedDaysTotal(timeStamp);
        integer day = lastDays - monthCount;
        return day;
    }
    private function GetLastSeconds(integer timeStamp) -> integer {
        return mod(timeStamp, lengthDay);
    }
    private function GetHour(integer timeStamp) -> integer {
        integer lastSeconds = GetLastSeconds(timeStamp);
        return lastSeconds / lengthHour;
    }
    private function GetMinute(integer timeStamp) -> integer {
        integer lastSeconds = GetLastSeconds(timeStamp);
        integer lastSecondsForMinute = mod(lastSeconds, lengthHour);
        return lastSecondsForMinute / lengthMinute;
    }
    private function GetSecond(integer timeStamp) -> integer {
        integer lastSeconds = GetLastSeconds(timeStamp);
        integer lastSecondsForSecond = mod(lastSeconds, lengthMinute);
        return lastSecondsForSecond;
    }

    public function XYConvertTimeStampToTime(integer timeStamp) -> string {
        integer year, month, day, hour, minute, second;

        timeStamp += 8 * 3600; // UTC +8
        year = GetYear(timeStamp);
        month = GetMonth(timeStamp);
        day = GetDay(timeStamp);
        hour = GetHour(timeStamp);
        minute = GetMinute(timeStamp);
        second = GetSecond(timeStamp);

        return I2S(year) + "/" + I2S(month) + "/" + I2S(day) + " " + I2S(hour) + ":" + I2S(minute) + ":" + I2S(second);
    }
}
//! endzinc
#undef mod

#endif
