// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:provider/provider.dart';

// class MediaUploadWidget extends StatelessWidget {
//   const MediaUploadWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final pengaduanProvider = Provider.of<PengaduanProvider>(context);

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 4,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//            Text(
//             "Upload Bukti (Foto/Video)",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: AppColors.secondary,
//             ),
//           ),
//           const SizedBox(height: 16),
//           pengaduanProvider.selectedFiles.isEmpty
//               ? _buildEmptyState(context, pengaduanProvider)
//               : _buildMediaGrid(context, pengaduanProvider),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyState(BuildContext context, PengaduanProvider pengaduanProvider) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.upload,
//             size: 48,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             "Belum ada bukti diunggah",
//             style: TextStyle(fontSize: 14, color: Colors.grey),
//           ),
//           const SizedBox(height: 12),
//           _buildUploadButton(context, pengaduanProvider),
//         ],
//       ),
//     );
//   }

//   Widget _buildMediaGrid(BuildContext context, PengaduanProvider pengaduanProvider) {
//     final itemCount = pengaduanProvider.selectedFiles.length + 1; 
//     return GridView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: itemCount,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//         childAspectRatio: 1,
//       ),
//       itemBuilder: (context, index) {
//         if (index == pengaduanProvider.selectedFiles.length) {
//           return GestureDetector(
//             onTap: () => _pickFiles(context, pengaduanProvider),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: AppColors.secondary.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: AppColors.secondary, width: 1),
//               ),
//               child:  Center(
//                 child: Icon(
//                   Icons.add,
//                   color: AppColors.secondary,
//                   size: 32,
//                 ),
//               ),
//             ),
//           );
//         }

//         final file = pengaduanProvider.selectedFiles[index];
//         final isImage = ['.jpg', '.jpeg', '.png'].any(
//           (ext) => file.path.toLowerCase().endsWith(ext),
//         );
//         final isVideo = file.path.toLowerCase().endsWith('.mp4');

//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => isVideo
//                     ? PreviewScreen(file: file)
//                     : PreviewImageFile(file: file),
//               ),
//             );
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey[300]!, width: 1),
//             ),
//             child: Stack(
//               children: [
//                 isImage
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.file(
//                           file,
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: double.infinity,
//                         ),
//                       )
//                     : Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.videocam,
//                               size: 36,
//                               color: Colors.grey[600],
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               "Video",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: GestureDetector(
//                     onTap: () {
//                       pengaduanProvider.removeFile(index);
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: Colors.redAccent,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.close,
//                         size: 16,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildUploadButton(BuildContext context, PengaduanProvider pengaduanProvider) {
//     return ElevatedButton.icon(
//       onPressed: () => _pickFiles(context, pengaduanProvider),
//       icon: const Icon(Icons.upload_file, size: 20),
//       label: const Text("Pilih Bukti"),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.secondary,
//         foregroundColor: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         elevation: 2,
//       ),
//     );
//   }

//   Future<void> _pickFiles(BuildContext context, PengaduanProvider pengaduanProvider) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowMultiple: true,
//       allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4'],
//     );
//     if (result != null) {
//       final files = result.paths.whereType<String>().map((path) => File(path)).toList();
//       pengaduanProvider.setSelectedFiles([...pengaduanProvider.selectedFiles, ...files]);
//     }
//   }
// }