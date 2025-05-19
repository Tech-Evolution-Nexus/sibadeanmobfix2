import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaModel.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/berita/detail_berita.dart';

class BeritaItem extends StatefulWidget {
  final Berita berita;
  final String variant;
  const BeritaItem(
      {super.key, required this.berita, this.variant = "horizontal"});

  @override
  State<BeritaItem> createState() => _BeritaItemState();
}

class _BeritaItemState extends State<BeritaItem> {
  @override
  Widget build(BuildContext context) {
    return widget.variant == "horizontal"
        ? variantHorizontal()
        : variantVertical();
  }

  Widget variantVertical() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailBerita(id: widget.berita.id.toInt()),
          ),
        );
      },
      child: Container(
        width: double.infinity, // lebar tetap untuk horizontal scroll
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.network(
                  widget.berita.gambar ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.berita.judul,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.berita.createdAt,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget variantHorizontal() {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailBerita(id: widget.berita.id.toInt()),
        ),
      ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6), // Border image
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(40), // Image radius
                    child: Image.network(
                      widget.berita.gambar ?? '', // URL gambar dari data
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Jika gagal load gambar, tampilkan gambar alternatif online
                        return Image.network(
                          widget.berita.gambar,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.berita.judul,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined, // Ikon jam
                              size: 14, // Ukuran ikon agar cocok dengan teks
                              color: Colors.grey.shade900,
                            ),
                            SizedBox(width: 4), // Jarak antara ikon dan teks
                            Text(
                              widget.berita.createdAt,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
