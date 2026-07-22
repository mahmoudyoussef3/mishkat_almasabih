import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> PrayerEntry {
        PrayerEntry(date: Date(), configuration: PrayerConfiguration.placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (PrayerEntry) -> ()) {
        let entry = PrayerEntry(date: Date(), configuration: getPrayerConfiguration(for: Date()))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [PrayerEntry] = []
        let currentDate = Date()
        
        let prefs = UserDefaults(suiteName: "group.com.mishkat_almasabih.app")
        
        let fajrMillis = prefs?.integer(forKey: "prayer_fajr_millis") ?? 0
        let sunriseMillis = prefs?.integer(forKey: "prayer_sunrise_millis") ?? 0
        let dhuhrMillis = prefs?.integer(forKey: "prayer_dhuhr_millis") ?? 0
        let asrMillis = prefs?.integer(forKey: "prayer_asr_millis") ?? 0
        let maghribMillis = prefs?.integer(forKey: "prayer_maghrib_millis") ?? 0
        let ishaMillis = prefs?.integer(forKey: "prayer_isha_millis") ?? 0
        let tomorrowFajrMillis = prefs?.integer(forKey: "prayer_tomorrow_fajr_millis") ?? 0
        
        let prayerDates = [
            ("fajr", Date(timeIntervalSince1970: TimeInterval(fajrMillis) / 1000.0)),
            ("sunrise", Date(timeIntervalSince1970: TimeInterval(sunriseMillis) / 1000.0)),
            ("dhuhr", Date(timeIntervalSince1970: TimeInterval(dhuhrMillis) / 1000.0)),
            ("asr", Date(timeIntervalSince1970: TimeInterval(asrMillis) / 1000.0)),
            ("maghrib", Date(timeIntervalSince1970: TimeInterval(maghribMillis) / 1000.0)),
            ("isha", Date(timeIntervalSince1970: TimeInterval(ishaMillis) / 1000.0)),
            ("tomorrow_fajr", Date(timeIntervalSince1970: TimeInterval(tomorrowFajrMillis) / 1000.0))
        ].filter { $0.1.timeIntervalSince1970 > 1000 } // Filter out invalid zeros

        // Entry for current time
        entries.append(PrayerEntry(date: currentDate, configuration: getPrayerConfiguration(for: currentDate)))
        
        // Entries for exactly at every prayer time in the future
        for (_, date) in prayerDates {
            if date > currentDate {
                entries.append(PrayerEntry(date: date, configuration: getPrayerConfiguration(for: date)))
            }
        }
        
        // Timeline refresh policy: after the last prayer we know about (tomorrow's fajr)
        // or sooner if Flutter updates the data
        let lastDate = prayerDates.last?.1 ?? Calendar.current.date(byAdding: .hour, value: 24, to: currentDate)!
        
        let timeline = Timeline(entries: entries, policy: .after(lastDate))
        completion(timeline)
    }
    
    private func getPrayerConfiguration(for date: Date) -> PrayerConfiguration {
        let prefs = UserDefaults(suiteName: "group.com.mishkat_almasabih.app")
        
        let hijri = prefs?.string(forKey: "prayer_hijri_date") ?? "التاريخ الهجري"
        let gregorian = prefs?.string(forKey: "prayer_gregorian_date") ?? "التاريخ الميلادي"
        
        let fajrTime = prefs?.string(forKey: "prayer_fajr") ?? "--:--"
        let sunriseTime = prefs?.string(forKey: "prayer_sunrise") ?? "--:--"
        let dhuhrTime = prefs?.string(forKey: "prayer_dhuhr") ?? "--:--"
        let asrTime = prefs?.string(forKey: "prayer_asr") ?? "--:--"
        let maghribTime = prefs?.string(forKey: "prayer_maghrib") ?? "--:--"
        let ishaTime = prefs?.string(forKey: "prayer_isha") ?? "--:--"
        
        let fajrMillis = prefs?.integer(forKey: "prayer_fajr_millis") ?? 0
        let sunriseMillis = prefs?.integer(forKey: "prayer_sunrise_millis") ?? 0
        let dhuhrMillis = prefs?.integer(forKey: "prayer_dhuhr_millis") ?? 0
        let asrMillis = prefs?.integer(forKey: "prayer_asr_millis") ?? 0
        let maghribMillis = prefs?.integer(forKey: "prayer_maghrib_millis") ?? 0
        let ishaMillis = prefs?.integer(forKey: "prayer_isha_millis") ?? 0
        
        var nextKey = "fajr"
        let nowInterval = date.timeIntervalSince1970 * 1000
        
        if nowInterval < Double(fajrMillis) { nextKey = "fajr" }
        else if nowInterval < Double(sunriseMillis) { nextKey = "sunrise" }
        else if nowInterval < Double(dhuhrMillis) { nextKey = "dhuhr" }
        else if nowInterval < Double(asrMillis) { nextKey = "asr" }
        else if nowInterval < Double(maghribMillis) { nextKey = "maghrib" }
        else if nowInterval < Double(ishaMillis) { nextKey = "isha" }
        else { nextKey = "fajr" } // Tomorrow's fajr
        
        return PrayerConfiguration(
            hijriDate: hijri,
            gregorianDate: gregorian,
            fajr: fajrTime,
            sunrise: sunriseTime,
            dhuhr: dhuhrTime,
            asr: asrTime,
            maghrib: maghribTime,
            isha: ishaTime,
            activeKey: nextKey
        )
    }
}

struct PrayerConfiguration {
    let hijriDate: String
    let gregorianDate: String
    let fajr: String
    let sunrise: String
    let dhuhr: String
    let asr: String
    let maghrib: String
    let isha: String
    let activeKey: String
    
    static let placeholder = PrayerConfiguration(
        hijriDate: "١٨ ذو القعدة ١٤٤٧ هـ",
        gregorianDate: "الثلاثاء، ٢٦ مايو ٢٠٢٦ م",
        fajr: "04:21", sunrise: "05:55", dhuhr: "12:53",
        asr: "16:30", maghrib: "19:49", isha: "21:05",
        activeKey: "fajr"
    )
}

struct PrayerEntry: TimelineEntry {
    let date: Date
    let configuration: PrayerConfiguration
}

struct PrayerTimesWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(entry.configuration.hijriDate)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color("PrayerWidgetAccent", bundle: nil) ?? .green)
                Spacer()
                Text(entry.configuration.gregorianDate)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 4)
            
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    PrayerItemView(label: "الفجر", time: entry.configuration.fajr, isActive: entry.configuration.activeKey == "fajr")
                    PrayerItemView(label: "الشروق", time: entry.configuration.sunrise, isActive: entry.configuration.activeKey == "sunrise")
                    PrayerItemView(label: "الظهر", time: entry.configuration.dhuhr, isActive: entry.configuration.activeKey == "dhuhr")
                }
                HStack(spacing: 4) {
                    PrayerItemView(label: "العصر", time: entry.configuration.asr, isActive: entry.configuration.activeKey == "asr")
                    PrayerItemView(label: "المغرب", time: entry.configuration.maghrib, isActive: entry.configuration.activeKey == "maghrib")
                    PrayerItemView(label: "العشاء", time: entry.configuration.isha, isActive: entry.configuration.activeKey == "isha")
                }
            }
        }
        .padding()
        .background(Color("PrayerWidgetBackground", bundle: nil) ?? Color(UIColor.systemBackground))
        .environment(\.layoutDirection, .rightToLeft)
    }
}

struct PrayerItemView: View {
    let label: String
    let time: String
    let isActive: Bool
    
    var body: some View {
        VStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(isActive ? Color("PrayerWidgetTextPrimary", bundle: nil) ?? .black : .gray)
            Text(time)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color("PrayerWidgetTextPrimary", bundle: nil) ?? .black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(isActive ? (Color("PrayerWidgetAccent", bundle: nil) ?? .green).opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

@main
struct PrayerTimesWidget: Widget {
    let kind: String = "PrayerTimesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PrayerTimesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("مواقيت الصلاة")
        .description("يعرض مواقيت الصلاة القادمة.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
